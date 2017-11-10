class Api::Device < Device
  attr_accessor :current_ip_address, :model_class_name, :signature, :module, :algo, :reset, :xmpp_account
  validate :validate_device_info
  validate :validate_model_name

  DEFAULT_MODULE_LIST = [{name: 'ddns', ver: '1'}, {name: 'upnp', ver: '1'}]

  def checkin

    instance = Device.includes(pairing: :invitations).find_by( mac_address: mac_address, serial_number: serial_number)

    # find country by ip from geoip database
    country = get_country

    if instance.blank?
      # instance 不存在的情形下：
      # self 的其他 attributes 是在 controller 的 device_checking 當中給值，Example: "@device = Api::Device::Vx.new(....)"，
      # 因此 self 會有 model_class_name，且須通過 validate_model_name 的驗證。
      self.attributes = { product_id: @product.id, ip_address: ip_encode_hex, online_status: true, country: country }
      self.save
      return true
    else
      attrs = { ip_address: ip_encode_hex, online_status: true, country: country }

      # 2017/9/28: 裝置在生產後，於工廠內可能先執行開機測試，因此開機時就會對 API Server 註冊，
      # 此情形並非使用者購買後的裝置註冊，因此會影響 BI 報表中每日註冊裝置數的精確度，
      # 經討論後，最終決議: 如果裝置註冊的 ip 國家與前一次不同，皆視同裝置轉賣至其他國家，
      # 因此更新裝置資訊時需更新 created_at 為當下時間。
      attrs[:created_at] = Time.now if instance.country != country
      attrs[:mac_address_of_router_lan_port] = self.mac_address_of_router_lan_port if self.mac_address_of_router_lan_port.present?

      # instance 是由 DB 所查詢出來的 device 資料，即使用 "Api::Device" 接也不會有 model_class_name 的值，
      # 因此當 instance 在 update 時，執行到 validate_model_name，就會出現錯誤，因為 model_class_name 是 nil，
      # 所以 instance 的物件型態不可設為 "Api::Device"，因 Api::Device 會執行 validate_model_name，
      # 且當 instance 已經存在 DB 當中時，因重複註冊並不會修改 model_class_name，因此 validate_model_name 可不被執行。
      instance.update(attrs)
    end
    
    # 如果 instance.firmware_version (from DB) 和 firmware_version (from parameters) 的值不同，則修改 firmware_version
    unless firmware_version == instance.firmware_version
      Rails.logger.info('update device from fireware version' + firmware_version + ' from ' + firmware_version)
      instance.update_attribute(:firmware_version, firmware_version)
    end

    # Device update 之後，因 self 的 attributes value 還沒有 refresh，
    # 所以將 self 的 attributes value refresh
    self.attributes.keys.each do |key|
      self.send("#{key}=", instance.send(key))
    end

    self.ddns = instance.ddns if instance.ddns.present?
    return true
  end

  # 每次device 登入，會更改DDNS 上的對應IP
  #
  # 以下情況忽略不做 update
  # * 這次登入的IP 跟 上一次的一樣
  # * 當device reset的時候
  # * 該device 還未做過DDNS 註冊
  def ddns_checkin

    ddns.update(ip_address: ddns.get_ip_addr, status: 0) if ddns.present? # if device log in again, its ddns status will be reset to 0.

    return unless ip_changed?
    return if reset_requestment?
    return if ddns.nil?

    ddns_session_data = { device_id: self.id, host_name: ddns.hostname, domain_name: Settings.environments.ddns, status: 'start' }
    ddns_session = DdnsSession.create
    job = {
      :job => 'ddns',
      :session_id => ddns_session.id,
      :device_id => self.id,
      :ip => current_ip_address,
      :full_domain => "#{ddns.hostname}.#{Settings.environments.ddns}",
      :xmpp_account => self.session['xmpp_account']
    }

    Rails.logger.info("device ip is changed, now creating ddns session: #{ddns_session_data}, and sending ddns queue: #{job}")
    ddns_session.session.bulk_set(ddns_session_data)
    AwsService.send_message_to_queue(job, 'bot_jobs', nil)
  end

  # 記錄下該Device 所需要的modules
  def install_module

    modules = parse_module_list(self.module) || DEFAULT_MODULE_LIST
    modules = modules.kind_of?(Array) ? modules : DEFAULT_MODULE_LIST

    self.module_list.clear
    self.module_version.clear
    module_version = {}
    modules.each do |item|
     module_list << item[:name].downcase unless item[:name].blank?
     module_version[item[:name].downcase] = item[:ver] unless item[:ver].blank?
    end

    self.module_version.bulk_set(module_version)
  end

  # 儲存或更新 device 使用的 IP 或 XMPP account
  def device_session_checkin

    xmpp_account = generate_new_username

    update_ip_list(current_ip_address) if ip_changed?

    if ip_changed? || xmpp_account != session['xmpp_account']
      device_session_data = { 'ip' => current_ip_address, 'xmpp_account' => xmpp_account }
      Rails.logger.info("create or update device session: #{device_session_data}, update device ip from #{self.session['ip']} to #{current_ip_address} !")
      self.session.bulk_set(device_session_data)
    end
  end

  # 如參數帶有reset=1的參數，並且該裝置已配對，則重設該台Device
  def reset_pairing
    unless reset_requestment?
      return
    end

    return if self.pairing.blank?

    PairingLog.record_pairing_log(self.pairing.first.user_id, self.id, self.ip_address, 'reset')

    self.pairing.destroy_all
    Job.new.push_device_id(self.id.to_s)
  end

  # 如果該台 device 沒有xmpp 帳號則註冊一組
  # 如果有，則device 每次連上來都會重設xmpp的帳號
  def xmpp_checkin

    self.xmpp_account = Hash.new
    self.xmpp_account[:password] = generate_new_passoword
    self.xmpp_account[:name] = session.fetch :xmpp_account || generate_new_username

    Rails.logger.info('apply xmpp account:' + self.xmpp_account[:name])
    apply_for_xmpp_account(self.xmpp_account)
  end

  # 此為直接連線至MongooseIM 的Db 直接存取修改帳XMPP的號密碼
  def apply_for_xmpp_account(account)

    xmpp_user = XmppUser.find_or_initialize_by(username: account[:name])
    xmpp_user.password = account[:password]
    xmpp_user.save

    xmpp_user.session = id

    current_timestamp = Time.now.to_i
    xmpp_last = XmppLast.find_by(username: account[:name])
    if xmpp_last.nil?
      xmpp_last = XmppLast.new
      xmpp_last.username = account[:name]
      xmpp_last.last_signout_at = current_timestamp - 1
      xmpp_last.state = ""
    end

    xmpp_last.last_signin_at = current_timestamp
    xmpp_last.save
  end

  def xmpp_username
    generate_new_username
  end

  # the value of @changed only defined once when device registering
  def ip_changed?
    @changed = (current_ip_address != session['ip']) if @changed.nil?
    @changed
  end

  private

    def reset_requestment?
      !reset.nil? && reset == 1.to_s
    end

    def parse_module_list(module_list)
      begin
        modules = JSON.parse(module_list, symbolize_names: true)
      rescue
        nil
      end
    end

    # 用Mac Address 和 序號的英數產生
    def generate_new_username
      'd' + mac_address.gsub(':', '-') + '-' + serial_number.gsub(/([^\w])/, '-')
    end

    #用英數產生密碼，大小寫有別
    def generate_new_passoword
      origin = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      (0...10).map { origin[rand(origin.length)] }.join
    end

    def validate_device_info
      mac_address_regex = /^[0-9a-fA-F]{12}$/

      if mac_address.blank? || mac_address_regex.match(mac_address) == nil || serial_number.blank?
        Rails.logger.info('result: invalid Mac Address or Serial Number')
        errors.add(:parameter, {result: 'invalid parameter'})
      end
    end

    def validate_model_name
      @product = Product.find_by(model_class_name: model_class_name)
      logger.debug("validate model name: " + @product.inspect)

      errors.add(:parameter, {result: 'invalid parameter'}) if @product.blank?
    end

    def get_country
      remote_ip = current_ip_address 
      remote_ip = "173.194.112.35" if Rails.env.development?
      ip_to_country(remote_ip)
    end

    def ip_to_country(ip)
      geoip = GeoIP.new(Settings.geoip.db_path)
      country = ""
      begin  
        # set local_ip_alias:
        # geoip.city("127.0.0.1") 
        # <struct GeoIP::City request="127.0.0.1", ip="173.194.112.35", country_code2="US", country_code3="USA", country_name="United States", continent_code="NA", region_name="CA", city_name="Mountain View", postal_code="94043", latitude=37.41919999999999, longitude=-122.0574, dma_code=807, area_code=650, timezone="America/Los_Angeles", real_region_name="California">
        # geoip.local_ip_alias = "173.194.112.35" if Rails.env.test?
        location = geoip.country(ip)
        country = location.country_code2 if location.country_code2 != '--'
      rescue Exception => e
        Rails.logger.error(e.message)
      end
      country
    end

end

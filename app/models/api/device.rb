class Api::Device < Device
  attr_accessor :current_ip_address, :model_class_name, :signature, :module, :algo, :reset, :xmpp_account
  validate :validate_device_info

  DEFAULT_MODULE_LIST = [{name: 'ddns', ver: '1'}, {name: 'upnp', ver: '1'}]

  def self.checkin args
    
    result = self.where( args.slice(:mac_address, :serial_number))
    if result.empty?

      product = Product.where(args.slice(:model_class_name))

      return nil if product.empty?

      instance = self.create(args.merge({product_id: product.first.id}))
      logger.info('create new device id:' + instance.id.to_s)

      instance.attributes = args
      return instance     
    end

    instance = result.first
    unless args[:firmware_version] == instance.firmware_version
      logger.info('update device from fireware version' + args[:firmware_version] + ' from ' + instance.firmware_version)
      instance.update_attribute(:firmware_version, args[:firmware_version])
    end
    
    instance.attributes = args
    return instance
  end

  # 每次device 登入，會更改DDNS 上的對應IP
  #
  # 以下情況忽略不做 update
  # * 這次登入的IP 跟 上一次的一樣
  # * 當device reset的時候
  # * 該device 還未做過DDNS 註冊
  def ddns_checkin

    device_session = self.session.all
    return if device_session['ip'] == current_ip_address
    return if reset_requestment?

    return if ddns.nil?

    logger.debug('update ddns id:' + ddns.id.to_s)
    service_logger.note({'update ddns ip from' => device_session['ip'], 'update fireware to' => request.remote_ip})

    session = {device_id: @device.id, host_name: ddns.hostname, domain_name: Settings.environments.ddns, status: 'start'}
    ddns_session = DdnsSession.create
    job = {:job => 'ddns', :session_id => ddns_session.id}
    ddns_session.session.bulk_set(session)
    AWS::SQS.new.queues.named(Settings.environments.sqs.name).send_message(job.to_json)
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

    update_ip_list(current_ip_address) if current_ip_address != session['ip']

    if current_ip_address != session['ip'] || xmpp_account != session['xmpp_account']
      session['ip'] = current_ip_address
      session['xmpp_account'] = xmpp_account
      logger.info('create or update device session: ' + session.inspect + ', raw data:' + session.inspect)
    end
  end

  # 如參數帶有reset=1的參數，並且該裝置已配對，則重設該台Device
  def reset_pairing
    unless reset_requestment?
      logger.debug("don't reset");
      return
    end

    return if pairing.nil?

    pairing.destroy
    Job::UnpairMessage.new.push_device_id(id.to_s)
  end

  # 如果該台 device 沒有xmpp 帳號則註冊一組
  # 如果有，則device 每次連上來都會重設xmpp的帳號
  def xmpp_checkin

    self.xmpp_account = Hash.new
    self.xmpp_account[:password] = generate_new_passoword
    self.xmpp_account[:name] = session.fetch :xmpp_account || generate_new_username

    logger.info('apply xmpp account:' + self.xmpp_account[:name])
    apply_for_xmpp_account(self.xmpp_account)
  end

  # 此為直接連線至MongooseIM 的Db 直接存取修改帳XMPP的號密碼
  def apply_for_xmpp_account(account)

    xmpp_user = XmppUser.find_or_initialize_by(username: account[:name])
    xmpp_user.password = account[:password]
    xmpp_user.save

    xmpp_user.session = id
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
        logger.info('result: invalid Mac Address or Serial Number')
        errors.add(:parameter, {result: 'invalid parameter'})
      end
    end
end
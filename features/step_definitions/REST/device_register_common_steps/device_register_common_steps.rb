

Given(/^the device with information$/) do |table|
  TestingHelper::create_product_table if Product.count == 0
  @device_given_attrs = table.rows_hash

  # 設定 device default 的 ip address
  if ENV['RAILS_TEST_IP_ADDRESS'].blank?
    if @device_given_attrs['ip_address'].present?
      set_device_ip_address(@device_given_attrs['ip_address'])
    end
  end

  reset_signature(@device_given_attrs)
end

Given(/^the device is registered$/) do
  @device_given_attrs['registeres'] = true
  model_class_name = TestingDevice.new(@device_given_attrs).model_class_name
  product = Product.find_by(model_class_name: model_class_name)

  # Todo: 
  # 1. 把 ip_encode_hex、ip_decode_hex 另外拉出單獨的 utility class 處理 
  # 2. Device before_save 應該執行 ip_encode_hex
  current_ip = Api::Device.new(current_ip_address: @device_given_attrs['ip_address']).ip_encode_hex

  @registered_device = Device.create(
    mac_address: @device_given_attrs['mac_address'],
    serial_number: @device_given_attrs['serial_number'],
    firmware_version: @device_given_attrs['firmware_version'],
    ip_address: current_ip,
    product_id: product.id,
    country: "US"
    )
end

Given(/^the device was registered "(.*?)" days ago$/) do |days|
  steps %{ Given the device is registered }
  time = days.to_i.days.ago
  @registered_device.update(
    created_at: time,
    updated_at: time
    )
end

Given(/^the device is not registered$/) do 
  @device_given_attrs['registeres'] = false
  device = Device.find_by( mac_address: @device_given_attrs['mac_address'], serial_number: @device_given_attrs['serial_number'] )
  expect(device).to be_nil
  
  username = TestingDevice.new(@device_given_attrs).xmpp_username
  xmpp_user = XmppUser.find_by(username: username)
  expect(XmppUser.find_by(username: username)).to be_nil
end

Then(/^the device country should be changed to "(.*?)"$/) do |country_code|
  @device = Device.find(@registered_device.id)
  expect(@device.country).to eq("TW")
end

Then(/^the device created_at should be the same value of updated_at$/) do
  expect(@device.created_at).to eq(@device.updated_at)
end

Then(/^the record in databases as expected$/) do
  @result = JSON.parse(last_response.body)
  check_rest_result_valid(@result)
end

When(/^the device's IP is "(.*?)"$/) do |ip|
  set_device_ip_address(ip)
end

When(/^the device "(.*?)" was be changed to "(.*?)"$/) do |key, value|
  @device_given_attrs["#{key}"] = value

  if key == 'ip_address'
    puts "original IP: #{ENV['RAILS_TEST_IP_ADDRESS']}"
    steps %{ When the device's IP is "#{value}" }
  end

  # if the invalid signature is not specified  
  reset_signature(@device_given_attrs) if key != 'signature'

  # if the invalid signature is specified  
  @invalid_signature = true if key == 'signature'
end

Then(/^the API should return success respond$/) do
  expect(last_response.status).to eq(200)
end

Then(/^the database does not have record$/) do
  steps %{ And the device is not registered }
end

Then(/^the database should not have any pairing records$/) do
  device = Device.find_by(mac_address: @device_given_attrs["mac_address"])
  pairing = Pairing.find_by(device_id: device.id)
  expect(pairing).to be_nil
end

Then(/^the database should not have any associate invitations and accepted users records$/) do
  device = Device.find_by(mac_address: @device_given_attrs["mac_address"])
  invitations = Invitation.find_by(device_id: device.id)
  expect(invitations).to be_nil

  accepted_users = AcceptedUser.find_by(invitation_id: @invitation_id)
  expect(accepted_users).to be_nil
end


# ---------------------------------- #
# -------- common functions -------- #
# ---------------------------------- #

# check the result of device register api 
def check_rest_result_valid(json_result)
  
	device = Api::Device.find_by(mac_address: @device_given_attrs['mac_address'], serial_number: @device_given_attrs['serial_number'])
	
  # device register 的流程應檢查的項目包含：
  # 1. API response 內容
  # 2. personal cloud db
  # 3. xmpp db
  # 4. redis

  # 確認 API response 內容
  check_device_register_json_response(device, json_result)

  # 確認 personal cloud db 內容
  check_device_register_db_result(device)

  # 確認 xmpp db 內容
  check_device_register_xmpp_db_result(device)

  # 確認 redis 內容
  check_device_register_redis_result(device)
end

def check_device_register_db_result(device)
	test_ip = ENV['RAILS_TEST_IP_ADDRESS']
	device_ip = device.ip_decode_hex
	expect(device_ip).to eq(test_ip), "expected device ip to be #{test_ip}, but got #{device_ip}"
  expect(device.country).to eq(geoip_country_code(test_ip))
end

# check device register api json response
def check_device_register_json_response(device, json_result)
  xmpp_account = TestingDevice.new(@device_given_attrs).xmpp_account
  expect(json_result["xmpp_account"]).to eq(xmpp_account)
  expect(json_result["xmpp_bots"]).to eq(Settings.xmpp.bots)
  expect(json_result["xmpp_ip_addresses"]).to eq(Settings.xmpp.nodes)
end

# check device register api xmpp db data
def check_device_register_xmpp_db_result(device)
  xmpp_username = TestingDevice.new(@device_given_attrs).xmpp_username
	db_user = XmppUser.find_by(username: xmpp_username)

  expect(db_user.username).to eq(xmpp_username)
  expect(db_user.password).not_to be_empty
  expect(XmppLast.find_by(username: xmpp_username).last_signin_at).to be_present
end

def check_device_register_redis_result(device)
  xmpp_username = TestingDevice.new(@device_given_attrs).xmpp_username
  device_session = Device.find(device.id).session.all
  test_ip = ENV['RAILS_TEST_IP_ADDRESS']
  expect(device_session["xmpp_account"]).to eq(xmpp_username)
  expect(device_session["ip"]).to eq(test_ip), "expected device session ip to be #{test_ip}, but got #{device.ip_decode_hex}"

  unless @device_given_attrs['module'].blank?
    # Check device module version session
    check_device_module_version_session(device)
  end
end

# 確認 device module version session 是否確實寫入 redis
def check_device_module_version_session(device)
  expect(device.module_version.all).to eq({"ddns" => "1", "pairing" => "button"})  
end

# get geoip country code from ip 
def geoip_country_code(ip)
  geoip = GeoIP.new(Settings.geoip.db_path)
  geoip.country(ip).country_code2
end

# set device ip address
def set_device_ip_address(ip)
  ENV['RAILS_TEST_IP_ADDRESS'] = ip
end



# ----------------------------------- #
# -------- modules & classes -------- #
# ----------------------------------- #


module DeviceXmppPresenter
  def xmpp_account
    "#{xmpp_username}@#{Settings.xmpp.server}/#{Settings.xmpp.device_resource_id}"
  end

  def xmpp_username
    throw Exception "the mac_address or serial_number not set for DeviceXmppPresenter !" if @mac_address.nil? || @serial_number.nil?
    'd' + @mac_address.gsub(':', '-') + '-' + @serial_number.gsub(/([^\w])/, '-')
  end
end


class TestingDevice 
  include DeviceXmppPresenter

  def initialize(device_attrs)
    device_attrs.each do |key , value|
      self.instance_variable_set("@#{key}", value)
    end
    @model_name = 'NAS325' if @model_name.blank?
    puts "instance variables of TestingDevice: #{self.instance_variables.to_json}"
  end

  def model_class_name
    @model_name
  end

end




# ----------------------- #
# -------- steps -------- #
# ----------------------- #

When(/^the device send "(.*?)" request to REST API \/d\/3\/register$/) do | action |
  @device_given_attrs["reset"] = 1 if action == "reset"
  if @device_given_attrs["registered"] == true
    create_device_pairing(@registered_device)
  end

  path = '//' + Settings.environments.api_domain + '/d/3/register'
  signature = create_signature(
    @certificate.serial,
    @device_given_attrs["mac_address"],
    @device_given_attrs["serial_number"],
    @device_given_attrs["model_name"],
    @device_given_attrs["firmware_version"]
  )

  @device_given_attrs["signature"] = signature unless @invalid_signature
  @device_given_attrs["certificate_serial"] = @certificate.serial

  post path, @device_given_attrs
end

Given(/^the device has a DDNS record, and ip is "(.*?)"$/) do |ip|
  Domain.find_or_create_by(domain_name: Settings.environments.ddns)
  TestingHelper.create_ddns(Device.first, ip)
end

Then(/^DDNS ip should be update to "(.*?)"$/) do |ip|
  expect(Ddns.first.ip_address).to eq(ip)
end

Then(/^XmppLast should record this device register sign in time$/) do
  username = Api::Device.first.xmpp_username
  expect(XmppLast.find_by(username: username).last_signin_at).to be_present
end

Then(/^the ip in device session should be the same as "(.*?)"$/) do |ip|

  expect(Device.first.session['ip']).to eq(ip)
end








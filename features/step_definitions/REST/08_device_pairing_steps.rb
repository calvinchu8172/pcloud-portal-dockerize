Given(/^an existing client app and access token record$/) do
  @oauth_client_app = FactoryGirl.create(:oauth_client_app)
  @oauth_access_token = FactoryGirl.create(:oauth_access_token, resource_owner_id: @user.id, application_id: @oauth_client_app.id, use_refresh_token: true)
end

When(/^device sends a POST request to "(.*?)" with:$/) do |path, table|
  data = table.rows_hash
  path = '//' + Settings.environments.api_domain + path

  if data["access_token"].nil?
    access_token = nil
  elsif data["access_token"].include?("INVALID")
    access_token = "invalid access_token"
  else
    access_token = @oauth_access_token.token
  end

  if data["certificate_serial"].nil?
    certificate_serial = nil
  elsif data["certificate_serial"].include?("INVALID")
    certificate_serial = "invalid certificate_serial"
  else
    certificate_serial = @certificate.serial
  end

  if data["cloud_id"].nil?
    cloud_id = nil
  elsif data["cloud_id"].include?("INVALID")
    cloud_id = "invalid cloud_id"
  else
    cloud_id = @cloud_id
  end

  if data["mac_address"].nil?
    mac_address = nil
  elsif data["mac_address"].include?("INVALID")
    mac_address = "invalid mac_address"
  else
    mac_address = @device.mac_address
  end

  if data["serial_number"].nil?
    serial_number = nil
  elsif data["serial_number"].include?("INVALID")
    serial_number = "invalid serial_number"
  else
    serial_number = @device.serial_number
  end

  if data["signature"].nil?
    signature = nil
  elsif data["signature"].include?("INVALID")
    signature = "invalid signature"
  else
    signature = create_signature(access_token, certificate_serial, cloud_id, mac_address, serial_number)
  end

  header 'X-Signature', signature

  body = {
    access_token: access_token,
    certificate_serial: certificate_serial,
    cloud_id: cloud_id,
    mac_address: mac_address,
    serial_number: serial_number
  }

  body.delete_if {|key, value| value.nil? }

  post path, body
end

Then(/^the user and the device have been paired$/) do
  pairing = Pairing.first
  expect(pairing.user_id).to eq(@user.id)
  expect(pairing.device_id).to eq(@device.id)
end

When(/^the device has been paired$/) do
  FactoryGirl.create(:pairing, user_id: @user.id, device_id: @device.id)
end


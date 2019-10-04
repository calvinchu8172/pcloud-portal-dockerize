When(/^device sends a DELETE request to "(.*?)" with:$/) do |path, table|

  data = table.rows_hash
  path = '//' + Settings.environments.api_domain + path

  if data["certificate_serial"].nil?
    certificate_serial = nil
  elsif data["certificate_serial"].include?("INVALID")
    certificate_serial = "invalid certificate_serial"
  else
    certificate_serial = @certificate.serial
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
    signature = create_signature(certificate_serial, mac_address, serial_number)
  end

  header 'X-Signature', signature

  body = {
    certificate_serial: certificate_serial,
    mac_address: mac_address,
    serial_number: serial_number
  }

  body.delete_if {|key, value| value.nil? }

  delete path, body
end

Then(/^the device has been unpaired$/) do
  expect(@device.pairing.blank?).to eq(true)
end

Then(/^the device has not been unpaired$/) do
  expect(@device.pairing.blank?).to eq(false)
end

Given(/^paired time is "(.*?)" minutes ago$/) do |time|
  @pairing.created_at = @pairing.created_at - time.to_i.minutes
  @pairing.save
end
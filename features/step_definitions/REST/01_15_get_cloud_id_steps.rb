When(/^client send a GET request to \/user\/(\d+)\/cloud_id with:$/) do |arg1, table|
  data = table.rows_hash
  path = '//' + Settings.environments.api_domain + "/user/1/cloud_id"

  if data["email"].nil?
    email = nil
  elsif data["email"].include?("INVALID")
    email = "invalid email"
  else
    email = @user.email
  end

  if data["certificate_serial"].nil?
    certificate_serial = nil
  elsif data["certificate_serial"].include?("INVALID")
    certificate_serial = "invalid certificate_serial"
  else
    certificate_serial = @certificate.serial
  end

  if data["signature"].nil?
    signature = nil
  elsif data["signature"].include?("INVALID")
    signature = "invalid signature"
  else
    signature = create_signature(certificate_serial, email)
  end

  get path, {
    certificate_serial: certificate_serial,
    email: email,
    signature: signature
    }
end

Then(/^the JSON response should include cloud_id:$/) do |table|
  data = table.rows_hash
  body_hash = JSON.parse(last_response.body)

  data.each do |key, value|
    expect(body_hash.key?(key)).to be true
    expect(body_hash.value?(@user.encoded_id)).to be true
  end
end

When(/^the user’s email has not confirmed within (\d+) days\.$/) do |arg1|
  @user.confirmed_at = nil
  @user.save
end

When(/^the user’s email has not confirmed over (\d+) days\.$/) do |arg1|
  @user.confirmed_at = nil
  @user.created_at = @user.created_at - 3.days
  @user.save
end
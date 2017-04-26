When(/^client send a POST request to \/user\/1\/register with:$/) do |table|

  ActionMailer::Base.deliveries.clear

  data = table.rows_hash
  path = '//' + Settings.environments.api_domain + "/user/1/register"

  @email = id = data["id"]
  password = data["password"]

  certificate_serial = @certificate.serial

  signature = create_signature(id, certificate_serial)

  signature = "" if data["signature"].include?("INVALID")

  unless data["Accept-Language"].blank?
    header 'Accept-Language', data["Accept-Language"]
  end

  post path, {
    id: id,
    password: password,
    certificate_serial: certificate_serial,
    signature: signature
  }
end

Then(/^Portal's language should be changed to "(.*?)"$/) do |language|
  user = User.find_by_email(@email)
  expect(I18n.locale).to eq(language.to_sym)
  expect(user.language).to eq(language)
end

Then(/^Portal's language should be changed to default locale$/) do
  user = User.find_by_email(@email)
  expect(I18n.locale).to eq(I18n.default_locale)
  expect(user.language).to eq(I18n.default_locale.to_s)
end
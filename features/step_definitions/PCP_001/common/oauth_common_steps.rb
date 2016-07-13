
Given(/^a user visits home page$/) do
  visit unauthenticated_root_path
end

Then(/^the user should see text "(.*?)" on the page$/) do |message|
  expect(page.body).to have_content(message)
end

Then(/^the user will see the message "(.*?)"$/) do |message|
	
  expect(page.body).to have_content(message)
end

Then(/^the user will redirect to Terms of Use page$/) do
  expect(page.current_path).to eq("/oauth/new")
end

Then(/^the user should login$/) do
  expect(page).to have_link I18n.t("labels.sign_out")
end

When(/^the user visits profile page$/) do
  find("a.member").click
end

When(/^the user click Terms of Use page$/) do
  page.find("label[class=checkbox_label]").click
  click_button "Confirm"
end

Then(/^the user will redirect to editing password page$/) do
  expect(page.current_path).to eq("/users/password/edit")
end

When(/^the user doesn't click Terms of Use page$/) do
  click_button "Confirm"
end

Then(/^user will stay in Terms of Use page$/) do
  expect(page.current_path).to eq("/oauth/new")
end

Then(/^the omniauth user should not see change password link$/) do
  expect(page).to have_no_link I18n.t("labels.change_password")
end


def set_omniauth(provider, email = "personal@example.com", opts = {})
  default = {provider: provider,
             uuid:      "1234",
             "#{provider}": {
                         email: email,
                         gender: "male",
                         first_name: "eco",
                         last_name: "work",
                         name: "ecowork",
                         locale: "en"
                       }
            }

  credentials = default.merge(opts)
  user_hash = credentials[provider]
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      "uid" => credentials[:uuid],
      "provider" => credentials[:provider],
      "info" => {
        "email" => user_hash[:email],
        "first_name" => user_hash[:first_name],
        "last_name" => user_hash[:last_name],
        "name" => user_hash[:name]
      },
      "extra" => {
        "raw_info" => {
          "gender" => user_hash[:gender],
          "locale" => user_hash[:locale]
        }
      }
  })
end

def set_invalid_omniauth(provider, opts = {})

  credentials = { provider: provider,
                  invalid: :invalid_crendentials
                 }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
end
When(/^the user click sign in with Google link and not grant permission$/) do
  set_invalid_omniauth(get_omniauth_provider('Google'))
  find(".google_signin_btn").click
end

When(/^the user click sign in with Google link$/) do
  find(".google_signin_btn").click
end
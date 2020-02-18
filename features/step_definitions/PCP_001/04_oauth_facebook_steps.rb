When(/^the user click sign in with Facebook link and not grant permission$/) do
  set_invalid_omniauth(get_omniauth_provider('Facebook'))
  find(".facebook_signin_btn").click
end

When(/^the user click sign in with Facebook link$/) do
  find(".facebook_signin_btn").click
end
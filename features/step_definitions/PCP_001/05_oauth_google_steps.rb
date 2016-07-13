
Given(/^the user was not a personal cloud member but with google account$/) do
  set_omniauth(:google_oauth2)
end

Given(/^the user was a personal cloud member with google account$/) do
  @user = TestingHelper.create_and_confirm
  @identity = FactoryGirl.create(:identity, user_id: @user.id, provider: "google_oauth2", uid: "1234")
  set_omniauth(:google_oauth2, @user.email)
end

When(/^the user click sign in with Google link and grant permission$/) do
  click_link "Google"
end

When(/^the user click sign in with Google link and not grant permission$/) do
  set_invalid_omniauth(:google_oauth2)
  click_link "Google"
end

When(/^the user click sign in with Google link$/) do
  click_link "Google"
end

When(/^the user grant permission$/) do
  # do nothing
end




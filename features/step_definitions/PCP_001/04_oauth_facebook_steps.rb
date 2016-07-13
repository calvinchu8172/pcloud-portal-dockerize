

Given(/^the user was not a member$/) do
  set_omniauth(:facebook)
end

Given(/^the user was a member$/) do
  @user = TestingHelper.create_and_confirm
  @identity = FactoryGirl.create(:identity, user_id: @user.id, provider: "facebook", uid: "1234")
  set_omniauth(:facebook, @user.email)
end

When(/^the user click sign in with Facebook link and grant permission$/) do
  click_link "Facebook"
end

When(/^the user click sign in with Facebook link and not grant permission$/) do
  set_invalid_omniauth(:facebook)
  click_link "Facebook"
end

When(/^the user click sign in with Facebook link$/) do
  click_link "Facebook"
end

When(/^the user grant permission$/) do
  # do nothing
end

Then(/^redirect to My Devices\/Search Devices page$/) do
  expect(page.current_path).to eq("/discoverer/index")
end


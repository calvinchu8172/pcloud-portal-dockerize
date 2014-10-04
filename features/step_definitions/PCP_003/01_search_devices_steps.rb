# Visit search page with a user
Given(/^a user visits search devices page$/) do
  @user = TestingHelper.create_and_signin
end

# Set a user have not device
When(/^the device didn't connection$/) do
  visit '/discoverer/index'
end

# Set a user have a device
When(/^the device connect$/) do
	@user
  device = TestingHelper.create_device
  visit '/discoverer/index'
end

When(/^another user paired the devics$/) do
  steps %{
   When the device connect
  }
  another_user = FactoryGirl.create(:user, email: 'other@example.com')
  another_user.save
  @another_device = TestingHelper.create_pairing(another_user.id)
end

Then(/^the user should not see this device is paired by another user$/) do
  expect(page).to_not have_content("/discoverer/check/#{@another_device.id}")
end

Then(/^the user should not see devices list$/) do
  expect(page).to_not have_selector('table.devices_list .device, a[href*="/discoverer/check"]')
end

Then(/^the user should see devices list$/) do
  expect(page).to have_selector('table.devices_list .device, a[href*="/discoverer/check"]')
end

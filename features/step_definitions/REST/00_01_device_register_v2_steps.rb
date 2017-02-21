
# ----------------------- #
# -------- steps -------- #
# ----------------------- #

When(/^the device send "(.*?)" request to REST API \/d\/2\/register$/) do | action |
	@device_given_attrs["reset"] = 1 if action == "reset"
	if @device_given_attrs["registered"] == true
		create_device_pairing(@registered_device)
	end

	# Call register API
  path = '//' + Settings.environments.api_domain + '/d/2/register'
  post path, @device_given_attrs
end

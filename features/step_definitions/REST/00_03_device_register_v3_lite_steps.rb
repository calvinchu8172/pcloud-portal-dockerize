
# ----------------------- #
# -------- steps -------- #
# ----------------------- #

When(/^the device send "(.*?)" request to REST API \/d\/3\/register\/lite$/) do | action |
  @device_given_attrs["reset"] = 1 if action == "reset"

  # Create pairing data of registered device if device is registered.
  # To understand the variable @is_device_registered, please steps check api_common_steps.rb:
  # * Given the device is registered
  # * Given the device is not registered
  if @is_device_registered
    create_rest_pairing(@registered_device)
  end

  path = '//' + Settings.environments.api_domain + '/d/3/register/lite'
  signature = create_signature(
    @certificate.serial,
    @device_given_attrs["mac_address"],
    @device_given_attrs["serial_number"],
    @device_given_attrs["model_name"],
    @device_given_attrs["firmware_version"])

  @device_given_attrs["signature"] = signature unless @invalid_signature
  @device_given_attrs["certificate_serial"] = @certificate.serial
  post path, @device_given_attrs
end

# --------------------------- #
# -------- functions -------- #
# --------------------------- #
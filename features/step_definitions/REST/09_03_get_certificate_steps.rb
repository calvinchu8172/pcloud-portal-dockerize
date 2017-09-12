When(/^client send a GET request to \/console\/device_certs\/{serial} with:$/) do |table|
  data = table.rows_hash
  path = '//' + Settings.environments.api_domain + "/console/device_certs/#{@certificate.serial}"

  params = {}
  cert_serial, description, content = nil
  unless data["certificate_serial"].blank?   
    cert_serial = data["certificate_serial"].include?("INVALID") ? data["certificate_serial"] : @certificate.serial
    params["certificate_serial"] = cert_serial 
  end

  # binding.pry
  signature = data["signature"].include?("INVALID") ? data["signature"] : create_signature_urlsafe(cert_serial, @certificate.serial)
  header 'X-Signature', signature
  get path, params
end
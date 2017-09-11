module ApiErrors

  def error(code)

    missing_param_code_modify = {}
    missing_param_code.each do |key, value|
      missing_param_code_modify[key] = "Missing Required Parameter: #{value}"
    end

    error = {
      "400.0"  => "Missing Required Header: X-Signature",
      "400.1"  => "Invalid signature",
      "400.3"  => "Invalid certificate_serial",
      "400.5"  => "Invalid app_id",
      "400.24" => "Device Not Found",
      # "400.25" => "Missing Required Parameter: cloud_id",
      "400.26" => "Invalid cloud_id",
      # "400.36" => "Missing Required Parameter: email",
      "400.37" => "Missing Required Header: X-Timestamp",
      "400.38" => "Invalid timestamp",
      "400.39" => "Invalid content",
      "401.0"  => "Invalid access_token",
      "401.1"  => "Access Token Expired",
      "403.0"  => "User Is Not Device Owner",
      "403.1"  => "Device Already Paired",
      "404.2"  => "User Not Found",
      "404.3"  => "APP Not Found"
    }

    error.merge! missing_param_code_modify

    error[code]
  end

  def response_error(code)
    status = code.split('.')[0]
    render :json => { code: code, message: error(code) }, status: status
  end

  def missing_param_code
    {
      '400.2'  => 'certificate_serial',
      '400.4'  => 'app_id' ,
      '400.6'  => 'access_token',
      '400.22' => 'mac_address',
      '400.23' => 'serial_number',
      '400.25' => 'cloud_id' ,
      '400.36' => 'email' ,
      '400.39' => 'name',
      '400.40' => 'redirect_uri' ,
      '400.41' => 'create_db',
      '400.42' => 'descriptions',
      '400.43' => 'content'
    }
  end

end
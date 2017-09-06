module CheckParams
  include ApiErrors

  def check_certificate_serial(params)
    unless params.has_key?("certificate_serial")
      return response_error("400.2")
    end

    certificate_serial = Api::Certificate.find_by_serial(params[:certificate_serial])
    if certificate_serial.nil?
      return response_error("400.3")
    end
  end

  def check_params(params, filter)

    params.delete("certificate_serial")
    params = params.sort{ |a,z| a<=>z }.to_h
    filter = filter.sort

    compare = filter - params.keys

    if compare.include?('app_id')
      return response_error("400.4")
    elsif compare.include?('access_token')
      return response_error("400.6")
    elsif compare.include?('cloud_id')
      return response_error("400.25")
    elsif compare.include?('mac_address')
      return response_error("400.22")
    elsif compare.include?('serial_number')
      return response_error("400.23")
    elsif compare.include?('email')
      return response_error("400.36")
    end

  end

end
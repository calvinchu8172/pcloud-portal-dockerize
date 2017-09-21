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

    if !compare.empty?
      return_params_error(compare)
    end
  end

  def return_params_error(compare)

    missing_param_code.each do |key, value|
      if compare.include?(value)
        return response_error(key)
      end
    end

  end

end
module CheckParams
  include ApiErrors

  def check_params(params, filter)

    params.delete("certificate_serial")
    params = params.sort{ |a,z| a<=>z }.to_h
    filter = filter.sort

    compare = filter - params.keys

    if compare.include?('app_id')
      return render :json => { code: "400.4", message: error("400.4") }, status: 400
    elsif compare.include?('access_token')
      return render :json => { code: "400.6", message: error("400.6") }, status: 400
    elsif compare.include?('cloud_id')
      return render :json => { code: "400.25", message: error("400.25") }, status: 400
    elsif compare.include?('mac_address')
      return render :json => { code: "400.22", message: error("400.22") }, status: 400
    elsif compare.include?('serial_number')
      return render :json => { code: "400.23", message: error("400.23") }, status: 400
    elsif compare.include?('email')
      return render :json => { code: "400.36", message: error("400.36") }, status: 400
    elsif compare.include?('description')
      return render :json => { code: "400.37", message: error("400.37") }, status: 400
    elsif compare.include?('content')
      return render :json => { code: "400.38", message: error("400.38") }, status: 400
    end
    

  end

end
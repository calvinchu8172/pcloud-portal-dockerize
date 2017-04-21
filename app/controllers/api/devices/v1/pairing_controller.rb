class Api::Devices::V1::PairingController < Api::Base
  include CheckSignature
  include CheckParams

  before_action do
    check_header_signature signature
  end

  before_action do
    check_certificate_serial valid_params
  end

  before_action do
    check_signature valid_params, signature
  end

  before_action do
    check_params valid_params, filter
  end

  before_action :doorkeeper_authorize!
  before_action :compare_cloud_id
  before_action :query_device
  before_action :query_pairing


  def create
    create_pairing
    render nothing: true, status: 200
  end

  private

    def valid_params
      # 會按照 strong parameter 的排序，決定 valid_params 的排序
      params.permit(:access_token, :certificate_serial, :cloud_id, :mac_address, :serial_number)
    end

    def signature
      request.headers["X-Signature"]
    end

    def filter
      ["access_token", "cloud_id", "mac_address", "serial_number"]
    end

    def check_header_signature(signature)
      if signature.nil?
        return render :json => { code: "400.0", message: error("400.0") }, status: 400
      end
    end

    def check_certificate_serial(params)
      unless params.has_key?("certificate_serial")
        return render :json => { code: "400.2", message: error("400.2") }, status: 400
      end

      certificate_serial = Api::Certificate.find_by_serial(params[:certificate_serial])
      if certificate_serial.nil?
        return render :json => { code: "400.3", message: error("400.3") }, status: 400
      end
    end

    def compare_cloud_id
      user = User.find_by_encoded_id(valid_params["cloud_id"])
      if user.nil?
        return render :json => { code: "400.26", message: error("400.26") }, status: 400
      end
      @resource_owner_id = doorkeeper_token.resource_owner_id
      if @resource_owner_id != user.id
        return render :json => { code: "400.26", message: error("400.26") }, status: 400
      end
    end

    def doorkeeper_unauthorized_render_options(error: nil)
      if doorkeeper_token.nil?
        { :json => { code: "401.0", message: error("401.0") } }
      elsif doorkeeper_token.expired?
        { :json => { code: "401.1", message: error("401.1") } }
      end
    end

    def query_device
      @device = Device.find_by(mac_address: valid_params["mac_address"], serial_number: valid_params["serial_number"])
      if @device.nil?
        return render :json => { code: "400.23", message: error("400.23") }, status: 400
      end
    end

    def query_pairing
      @pairing = Pairing.find_by(user_id: @resource_owner_id, device_id: @device.id)
      if @pairing
        return render :json => { code: "403.1", message: error("403.1") }, status: 403
      end
    end

    def create_pairing
      Pairing.create(user_id: @resource_owner_id, device_id: @device.id, ownership: 0)
    end

end

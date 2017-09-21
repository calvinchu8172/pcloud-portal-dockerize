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

    def filter
      ["access_token", "cloud_id", "mac_address", "serial_number"]
    end

    def compare_cloud_id
      user = User.find_by_encoded_id(valid_params["cloud_id"])
      if user.nil?
        return response_error("400.26")
      end
      @resource_owner_id = doorkeeper_token.resource_owner_id
      if @resource_owner_id != user.id
        return response_error("400.26")
      end
    end

    def doorkeeper_unauthorized_render_options(error: nil)
      if doorkeeper_token.nil?
        { :json => { code: "401.0", message: error("401.0") } }
      elsif doorkeeper_token.revoked?
        { :json => { code: "401.0", message: error("401.0") } }
      elsif doorkeeper_token.expired?
        { :json => { code: "401.1", message: error("401.1") } }
      else
        { :json => { code: "401.0", message: error("401.0") } }
      end
    end

    def query_device
      @device = Device.find_by(mac_address: valid_params["mac_address"], serial_number: valid_params["serial_number"])
      if @device.nil?
        return response_error("400.24")
      end
    end

    def query_pairing
      @pairing = Pairing.find_by(user_id: @resource_owner_id, device_id: @device.id)
      if @pairing
        return response_error("403.1")
      end
    end

    def create_pairing
      Pairing.create(user_id: @resource_owner_id, device_id: @device.id, ownership: 0)
    end

end

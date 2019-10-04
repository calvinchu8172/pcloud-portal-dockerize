class Api::Devices::V1::PairingController < Api::Base
  include CheckSignature
  include CheckParams

  before_action do
    check_header_signature signature
  end

  before_action only: [:create] do
    check_certificate_serial valid_params
  end

  before_action only: [:create] do
    check_signature valid_params, signature
  end

  before_action only: [:create] do
    check_params valid_params, filter
  end

  before_action :doorkeeper_authorize!, only: [:create]
  before_action :compare_cloud_id, only: [:create]

  before_action only: [:create] do
    query_device valid_params["mac_address"], valid_params["serial_number"]
  end

  before_action :query_pairing, only: [:create]


  before_action only: [:destroy] do
    check_certificate_serial destroy_params
  end

  before_action only: [:destroy] do
    check_signature destroy_params, signature
  end

  before_action only: [:destroy] do
    check_params destroy_params, destroy_filter
  end

  before_action only: [:destroy] do
    query_device destroy_params["mac_address"], destroy_params["serial_number"]
  end

  before_action :query_pairings, only: [:destroy]


  def create
    create_pairing
    render nothing: true, status: 200
  end

  def destroy
    destroy_pairings
    @device.pairing
    render json: @device.pairing, status: 200
  end

  private

    def valid_params
      # 會按照 strong parameter 的排序，決定 valid_params 的排序
      params.permit(:access_token, :certificate_serial, :cloud_id, :mac_address, :serial_number)
    end

    def destroy_params
      params.permit(:certificate_serial, :mac_address, :serial_number)
    end

    def filter
      ["access_token", "cloud_id", "mac_address", "serial_number"]
    end

    def destroy_filter
      ["mac_address", "serial_number"]
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

    def query_device mac_address, serial_number
      @device = Device.find_by(mac_address: mac_address, serial_number: serial_number)
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

    def query_pairings
      @pairings = @device.pairing
      if @pairings.blank?
        return response_error("400.28")
      end
    end

    def create_pairing
      Pairing.create(user_id: @resource_owner_id, device_id: @device.id, ownership: 0)
    end

    def destroy_pairings
      @pairings.each do |pairing|
        if check_pairing_over_time? pairing, 10
          pairing.destroy
          Job.new.push_device_id(@device.id.to_s)
        end
      end
    end

    def check_pairing_over_time? pairing, how_many_minutes
      if Time.now.to_i - pairing.created_at.to_i > how_many_minutes.minutes.to_i
        true
      else
        false
      end
    end

end

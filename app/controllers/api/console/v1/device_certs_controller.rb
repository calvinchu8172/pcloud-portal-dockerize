class Api::Console::V1::DeviceCertsController < Api::Base
  include CheckSignature
  include CheckParams

  before_action do
    check_header_timestamp timestamp
  end

  before_action do
    check_header_signature signature
  end

  before_action do
    check_timestamp_valid timestamp
  end

  before_action do
    check_certificate_serial valid_params
  end

  before_action do
    check_signature_urlsafe valid_params, signature
  end

  before_action do
    check_params valid_params, filter
  end

  # List Device Certificates API
  def index
    device_certs = Api::Certificate.all
    render :json => {
        "data" => device_certs.map{ |dc| dc.data }
      }, status: 200
  end

  def show
    device_cert = Api::Certificate.find_by_serial(valid_params[:serial])
    render :json => {
      "data" => device_cert.data
    }, status: 200
  end

  def create
    device_cert = Api::Certificate.new
    device_cert.serial = SecureRandom.uuid
    device_cert.description = valid_params[:description]
    device_cert.content = valid_params[:content]
    unless device_cert.valid_content?
      return render :json => { code: "400.44", message: error("400.44") }, status: 400
    end
    device_cert.save
    render :json => {
      "data" => device_cert.data
    }, status: 200
  end

  def update
    device_cert = Api::Certificate.find_by_serial(valid_params[:serial])
    device_cert.description = valid_params[:description]
    unless valid_params[:content].blank?
      device_cert.content = valid_params[:content]
      unless device_cert.valid_content?
        return render :json => { code: "400.44", message: error("400.44") }, status: 400
      end
    end
    # device_cert.update(update_data)
    device_cert.save
    render :json => {
      "data" => device_cert.data
    }, status: 200
  end

  private

    def valid_params
      params.permit(:serial, :certificate_serial, :content, :description)
    end

    def filter
      required_params = []
      required_params = ["content", "description"] if action_name.eql? "create"
      required_params = ["description"] if action_name.eql? "update"
      required_params
    end

end

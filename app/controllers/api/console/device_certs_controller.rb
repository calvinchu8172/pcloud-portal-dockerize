class Api::Console::DeviceCertsController < Api::Base
  include CheckSignature
  include CheckParams

  before_action do
    check_header_signature signature
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
    device_certs = Api::Certificate.select(:id, :serial, :description)
    render :json => { 
        "data" => device_certs.map{ |dc| dc.serializable_hash }
      }, status: 200
  end

  def show
    device_cert = Api::Certificate.find(valid_params[:id])
    render :json => { 
      "data" => device_cert.data
    }, status: 200
  end

  def create
    device_cert = Api::Certificate.new
    device_cert.serial = SecureRandom.uuid
    device_cert.description = valid_params[:description]
    device_cert.content = valid_params[:content]
    device_cert.save
    render :json => { 
      "data" => device_cert.data
    }, status: 200
  end

  def update 
    device_cert = Api::Certificate.find(valid_params[:id])
    update_data = Hash.new
    update_data["description"] = valid_params[:description]
    unless valid_params[:content].blank? 
      update_data["content"] = valid_params[:content]  
    end
    device_cert.update(update_data)
    render :json => { 
      "data" => device_cert.data
    }, status: 200
  end

  private 

    def valid_params
      params.permit(:id, :certificate_serial, :content, :description)
    end

    def signature
      request.headers["X-Signature"]
    end

    def filter
      required_params = []
      required_params = ["content", "description"] if action_name.eql? "create"
      required_params = ["description"] if action_name.eql? "update"
      required_params
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

end

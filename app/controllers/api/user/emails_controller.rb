class Api::User::EmailsController < Api::Base
  before_filter :authenticate_user_by_token_include_unconfirmed!, only: :update
  before_action :check_params, :only => :get_cloud_id
  before_action :check_email, :only => :get_cloud_id
  before_action :check_certificate_serial, :only => :get_cloud_id
  before_action :check_signature, :only => :get_cloud_id

  def show
    user = Api::User::Email.new(show_params)
    user.valid?
    return render json: Api::User::INVALID_SIGNATURE_ERROR, :status => 400 unless user.errors['signature'].blank?

    render json: user.find_by_cloud_ids.to_json
  end

  def update
    user = Api::User::Email.find_by_encoded_id(valid_params[:cloud_id])
    return render json: { error_code: '006', description: 'the user has been confirmed' }, :status => 400 if user.confirmed?

    user.new_email = valid_params[:new_email]
    unless user.update_email
      return render json: user.errors[:email].first, :status => 400 unless user.errors[:email].blank?
    end

    render json: {result: 'success'}
  end

  def get_cloud_id
    cloud_id = @user.encoded_id

    render json: { cloud_id: cloud_id }
  end

  private
    def valid_params
      params.permit(:cloud_id, :authentication_token, :new_email)
    end

    def show_params
      params.permit(:cloud_ids, :certificate_serial, :signature)
    end

    def get_cloud_id_params
      params.permit(:email, :certificate_serial, :signature)
    end

    def check_params
      if get_cloud_id_params.keys != ["email", "certificate_serial", "signature"]
        return render :json => { error_code: "000", description: "Missing required params." }, status: 400
      end
      get_cloud_id_params.values.each do |value|
        return render :json => { error_code: "000", description: "Missing required params." }, status: 400 if value.blank?
      end
    end

    def check_email
      @user = Api::User::Email.find_by_email(get_cloud_id_params[:email])
      if @user.blank?
        return render :json => { error_code: "001", description: "Invalid email." }, status: 400
      end
      unless @user.confirmed?
        unless @user.confirmation_valid?
          # cloud_id = @user.encoded_id
          # render json: { cloud_id: cloud_id }
          # return render :json => { error_code: "002", description: "Client has to confirm email but it is still within 3 days trial period." }, status: 400
        # else
          return render :json => { error_code: "022", description: "Client has to confirm email account to continue. It has been expired over #{@user.expired_days} days." }, status: 400
        end
      end
    end

    def check_certificate_serial
      certificate_serial = Api::Certificate.find_by_serial(get_cloud_id_params[:certificate_serial])
      if certificate_serial.blank?
        return render :json => { error_code: "013", description: "Invalid certificate serial." }, status: 400
      end
    end

    def check_signature
      key = get_cloud_id_params[:certificate_serial] + get_cloud_id_params[:email]
      signature = get_cloud_id_params[:signature]
      certificate_serial = get_cloud_id_params[:certificate_serial]

      return render :json => { error_code: "101", description: "Invalid signature." }, status: 400 unless validate_signature(signature, key, certificate_serial)
    end

    def validate_signature(signature, key, serial)
      sha224 = OpenSSL::Digest::SHA224.new
      begin
        result = Api::Certificate.find_public_by_serial(serial).verify(sha224, Base64.decode64(signature), key)
        return result
      rescue
        return false
      end
    end

end

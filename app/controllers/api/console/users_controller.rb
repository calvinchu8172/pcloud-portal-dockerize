class Api::Console::UsersController < Api::Base
  include CheckSignature
  include CheckParams

  before_action only: [:revoke] do
    check_header_timestamp timestamp
  end

  before_action only: [:revoke] do
    check_header_signature signature
  end

  before_action only: [:revoke] do
    check_timestamp_valid timestamp
  end

  before_action only: [:revoke] do
    check_certificate_serial valid_params
  end

  before_action only: [:revoke] do
    check_signature_urlsafe valid_params, signature
  end

  before_action only: [:revoke] do
    check_params valid_params, filter
  end

  def revoke
    user = User.find_by_email(valid_params[:email])
    if user.blank?
      return response_error("404.2")
    end
    Pairing.where(user_id: user.id).destroy_all
    AcceptedUser.where(user_id: user.id).destroy_all
    VendorDevice.where(user_id: user.id).destroy_all
    Doorkeeper::AccessGrant.where(resource_owner_id: user.id).update_all(revoked_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
    Doorkeeper::AccessToken.where(resource_owner_id: user.id).update_all(revoked_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
    user.skip_reconfirmation!
    user.update_attributes(revoked_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
    user.update_column(:email, SecureRandom.hex(10))

    render nothing: true, status: 200
  end

  private

    def valid_params
      # 會按照 strong parameter 的排序，決定 valid_params 的排序
      params.permit(:certificate_serial, :email)
    end

    def filter
      ["email"]
    end

end
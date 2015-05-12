class OauthController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :register

  def new
    @user = User.new
  end

  def confirm
    agreement = params[:user][:agreement]
    if agreement == "1"
      # Check provider and user
      identity = User.sign_up_omniauth(session["devise.omniauth_data"], current_user, agreement)
      # Sign In and redirect to root path
      sign_in identity.user
      redirect_to authenticated_root_path
    else
      # Redirect to Sign in page, when user un-agreement the terms
      flash[:notice] = I18n.t('activerecord.errors.messages.accepted')
      redirect_to '/oauth/new'
    end
  end

  # GET /user/1/checkin/:oauth_provider
  def checkin
    provider = params[:oauth_provider]
    user_id  = params[:user_id]

    @user = Identity.find_by(uid: user_id, provider: provider)

    if @user.nil?
      render :json => { :error_code => '001',  :description => 'unregistered' }, :status => 400
    elsif @user.user.confirmation_token.nil?
      render :json => { :error_code => '002',  :description => 'not binding yet' }, :status => 400
    else
      render :json => { :result => 'registered', :account => @user.user.email }, :status => 200
    end
  end


  # POST /user/1/register/:oauth_provider
  def register
    provider     = params[:oauth_provider]
    user_id      = params[:user_id]
    access_token = params[:access_token]
    password     = params[:password]

    @user = Identity.find_by(uid: user_id, provider: provider)

    if !password.length.between?(8, 14)
      render :json => { :error_code => '002',  :description => 'Password has to be 8-14 characters length' }, :status => 400
    elsif !@user.nil?
      render :json => { :error_code => '003',  :description => 'registered account' }, :status => 400
    else
      identity = signup_fb_user(user_id, access_token, password)
      sign_in identity.user
      redirect_to authenticated_root_path
    end

  end


  private

  def validate_signature
    user_id      = params[:user_id] || ''
    access_token = params[:access_token] || ''
    password     = params[:password] || ''
    certificate  = params[:certificate] || ''
    signature    = params[:signature] || ''

    data             = certificate + user_id + access_token + password
    digest           = OpenSSL::Digest::SHA256.new
    private_key      = OpenSSL::PKey::RSA.new(File.read(private_key_file))
    signature_inside = private_key.sign(digest, data)

    unless signature == signature_inside
      render :json => {:error_code => '005', :description => 'invalid signature'}, :status => 400
    end
  end

  def signup_fb_user(user_id, access_token, password)

    data = FbGraph2::User.new(user_id).authenticate(access_token).fetch.raw_attributes

    identity = Identity.where(provider: 'facebook', uid: data["id"] ).first_or_initialize

    if identity.user.blank?
      user = User.new
      user.skip_confirmation!
      user.email = data.email
      user.password = password
      # user.fetch_details(data)
      user.edm_accept = "0"
      user.agreement = "1"
      user.save!

      identity.user = user
      identity.save!
    end
    identity
  end

end
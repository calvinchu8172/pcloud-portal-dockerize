class ApplicationController < ActionController::Base
  include ExceptionHandler
  include Locale
  include OauthFlow

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  # rescue_from ActionController::RoutingError, with: :routing_error
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :check_skip_confirm
  before_action :check_user_confirmation_expire, unless: :devise_controller?
  after_action :clear_log_context
  before_filter :setup_log_context
  
  # For cucumber test
  before_filter :mock_ip_address 


  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    setup_log_context

    logger.warn "routing error path: #{request.path}, id: #{request.session_options[:id].to_s}"
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end

  def service_logger
    Fluent::Logger.service_logger
  end

  protected

    def setup_log_context
      Log4r::MDC.put("pid", Process.pid)
      Log4r::MDC.put("ip", request.remote_ip)
      Log4r::MDC.put("user_id", current_user.id) if defined?(current_user) && !(current_user.blank?)
      Log4r::MDC.put("host", Socket.gethostname)
      Log4r::MDC.put("environment", Rails.env)
    end

    def clear_log_context
      Log4r::MDC.get_context.keys.each {|k| Log4r::MDC.remove(k) }
    end

    # def routing_error
    #   setup_log_context
    #   render :file => 'public/404.html', :status => :not_found, :layout => false
    # end

    def configure_devise_permitted_parameters
      registration_params = [:first_name, :middle_name, :last_name, :display_name, :email, :password, :password_confirmation, :gender, :mobile_number, :birthday, :language, :edm_accept, :agreement, :country]

      if params[:action] == 'update'
        devise_parameter_sanitizer.for(:account_update) {
        	|u| u.permit(registration_params << :current_password)
        }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) {
        	|u| u.permit(registration_params)
        }
      end
    end

    # Redirect back to current page after sign in
    def store_location
      return unless request.get?
      if(!request.path.match("/users") &&
         !request.path.match("/hint") &&
         !request.path.match("/oauth") &&
         !request.path.match("/help") &&
         !request.xhr? && # don't store ajax calls
         (request.accept && !request.accept.match(/json/))) # don't store json calls
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || session[:previous_url] || authenticated_root_path
    end

    def device_paired_with?
      @device = Device.find_by_encoded_id(params[:id])
      if @device.pairing.present? && @device.pairing.owner.first.user_id != current_user.id
        flash[:alert] = I18n.t('warnings.invalid_device')
        redirect_to :authenticated_root
      end
    end

    def check_user_confirmation_expire
      return if current_user.nil?

      if !current_user.confirmed? && !!warden.session['skip_confirm'] == false
        store_location_for(current_user, request.fullpath)
        redirect_to new_user_confirmation_path
      end
    end

    def check_skip_confirm
      if params['skip_confirm'] == 'true'
        warden.session['skip_confirm'] = Time.now.to_i

        # 如果 devise stored_location_for 有值
        if stored_location = stored_location_for(current_user)
          redirect_to stored_location
        end
      end
    end

    # for cucumber test
    # override remote_ip to set the fake ip 
    def mock_ip_address
      if Rails.env == 'test'
        unless ENV['RAILS_TEST_IP_ADDRESS'].blank?
          puts "mock_ip_address(): ENV['RAILS_TEST_IP_ADDRESS'] = #{ENV['RAILS_TEST_IP_ADDRESS']}" 
        end
        test_ip = ENV['RAILS_TEST_IP_ADDRESS']
        unless test_ip.nil? or test_ip.empty?
          request.instance_eval <<-EOS
            def remote_ip
              "#{test_ip}"
            end
          EOS
        end
      end
    end

end

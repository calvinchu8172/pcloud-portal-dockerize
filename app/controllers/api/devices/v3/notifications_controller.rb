class Api::Devices::V3::NotificationsController < Api::Base
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

  def create 
    device = Device.find_by(mac_address: valid_params[:mac_address], serial_number: valid_params[:serial_number])
    return response_error("400.24") if device.blank?

    pairing = Pairing.find_by(device_id: device.id)
    return response_error("400.28") if pairing.blank?
    
    template = Template.find_by(identity: valid_params[:template_id])
    return response_error("400.32") if template.blank?

    begin 
      template_params = JSON.parse(valid_params[:template_params])
    rescue Exception => e
      logger.error("Parse template params failed: #{e.message}")
      return response_error("400.35")
    end

    en_template_content = template.template_contents.select{ |tc| tc.locale == 'en' }.first
    matches = en_template_content.content.scan(/\#\{([a-zA-Z]\w*)\}/)
    t_content_params = matches.flatten

    if (t_content_params - template_params.keys).length > 0
      return response_error("400.34")
    end

    localizations = {}
    template.template_contents.each do |tc|
      localizations[tc.locale.to_sym] = {
        title: tc.title
      }
      t_content = tc.content
      t_content_params.each do |p_name|
        t_content.gsub!('#{'+p_name+'}', template_params[p_name])
      end
      localizations[tc.locale.to_sym][:body] = t_content
    end

    request_id = request.headers.env["action_dispatch.request_id"]
    sqs = AWS::SQS.new
    queue = sqs.queues.named(Settings.environments.sqs.push_jobs.name)
    begin
      queue.send_message(localizations.to_json, {
        :message_attributes => { 
          "cloud_id" => { 
          :string_value => pairing.user.encoded_id, :data_type => 'String'
          },
          "title" => { 
            :string_value => en_template_content.title, :data_type => 'String'
          },
          "request_id" => { 
            :string_value => request_id, :data_type => 'String'
          } 
        }
      })
    rescue Exception => e
      logger.error("Send Push Job Failed: #{e.message}")
      return response_error("500.0")
    end
    
    render json: { request_id: request_id }, status: 200
  end

  private
  
    def valid_params
      params.permit(:certificate_serial, :app_group_id, :mac_address, :serial_number, :template_id, :template_params)
    end

    def filter
      ["app_group_id", "mac_address", "serial_number", "template_id", "template_params"]
    end


end
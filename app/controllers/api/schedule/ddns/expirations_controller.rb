class Api::Schedule::Ddns::ExpirationsController < Api::Base

	def index
		log_array = Services::DdnsExpire.notice
    info = {
      :event => "[DDNS_CRON] notice by email",
      :count => log_array.size,
      :result => log_array
    }.to_json
    Rails.logger.info(info);
    render :json => info, status: 200
	end
	
	def destroy
    log_array = Services::DdnsExpire.delete
    info = {
      :event => "[DDNS_CRON] delete ddns and route53",
      :count => log_array.size,
      :result => log_array
    }.to_json
    Rails.logger.info(info);
    render :json => info, status: 200
	end

end
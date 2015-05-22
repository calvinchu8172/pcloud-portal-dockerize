class Api::Resource::InvitationsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_filter :validate_index_params, :only => [:index]
	before_filter :validate_create_params, :only => [:create]

	def index
		result = Array.new
		user = User.find_by_encrypted_id(params[:cloud_id])
		return render_error_response "012" if user.blank?

		user.invitations.each do |invitation| 
			device = invitation.device
			invitation.accepted_users.each do |accepted_user|
				next unless accepted_user.inbox?(params[:last_updated_at])
				result.push({ invitation_key: invitation.key,
					device_id: device.id,
					share_point: invitation.share_point,
					permission: invitation.permission_name,
					accepted_user: accepted_user.user.email,
					accepted_time: accepted_user.accepted_time })
			end
		end 
		result.sort_by! { |data| -Time.parse(data[:accepted_time]).to_i }
		render :json => result, status: 200
	end

	def create
		cloud_id = params[:cloud_id] || ''
		share_point = params[:share_point] || ''
		device_id = params[:device_id] || '1'
		permission = params[:permission] || '1'
		expire_count = params[:expire_count] || '5'

		device = Device.find_by_encrypted_id( device_id )

		return render_error_response "004" if device.blank?
		device_id = device.id

		#組成字串
		invitation_key =  cloud_id + share_point + device_id.to_s + Time.now.to_s   
		#加密
		#require 'digest/hmac'
		#Digest::HMAC.hexdigest(invitation_key, "hash key", Digest::SHA1)
		invitation_key = Digest::HMAC.hexdigest(invitation_key, "hash key", Digest::SHA1).to_s

		invitation = Invitation.new( :key => invitation_key, :share_point => share_point, :permission => permission, :device_id => device_id, :expire_count => expire_count )
		invitation.save
		
		render :json => { invitation_key: invitation_key }, status: 200
	end

	def validate_index_params
		params[:last_updated_at] = params[:last_updated_at].blank? ? 0 : params[:last_updated_at].to_i
		render_error_response "012" if params[:cloud_id].blank? #|| params[:authentication_token].blank?
	end

	def validate_create_params
		cloud_id = params[:cloud_id] || ''
		device_id = params[:device_id] || ''
		permission = params[:permission] || ''

		user = User.find_by_encrypted_id( cloud_id )
		device = Device.find_by_encrypted_id( device_id )
		pairing = Pairing.find_by_device_id( device.id )

		return render_error_response "012" if user.blank?
		return render_error_response "004" if device.blank? || pairing.user_id.to_s != user.id.to_s 
		return render_error_response "005" if permission != '1' && permission != '2' 
	end

	def render_error_response error_code
		error_descriptions = {
			"004" => "invalid device.",
			"005" => "Invalid share point and permission.",
			"012" => "invalid cloud id or token.",
			"013" => "invalid certificate.",
			"014" => "invalid signature."
		}
		render :json => { error_code: error_code, description: error_descriptions[error_code] }, status: 400
	end
end
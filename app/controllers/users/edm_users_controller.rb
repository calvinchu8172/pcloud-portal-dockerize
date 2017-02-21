class Users::EdmUsersController < ApplicationController

  before_action :authenticate_user!
  before_action :admin_auth!

  def index
  end

  def download_csv
    users = User.order(:id)
    attributes = ["email", "edm_accept", "language", "country", "sign_on_by"]

    csv_string = CSV.generate do |csv|
      csv << attributes
      users.each do |user|
        csv << [
          user.email,
          user.edm_accept.blank? ? false : user.edm_accept,
          user.language,
          user.country,
          check_sign_on_by(user)
        ]
      end
    end

    send_data(csv_string, filename: filename, type: 'text/csv; charset=utf-8')
  end

  private

    def filename
      "EDM-Users-List-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
    end

    def check_sign_on_by(user)
      method = ''
      
      if user.confirmation_token
        method = 'email'
        if user.confirmed_at.blank?
          method += '(unverified)'
        end
      end

      if !user.identity.find_by_provider('facebook').blank?
        if method == ''
          method += 'facebook'
        else
          method += '/facebook'
        end
      end

      if !user.identity.find_by_provider('google_oauth2').blank?
        if method == ''
          method += 'google_oauth2'
        else
          method += '/google_oauth2'
        end
      end

      method
    end

    def admin_auth!
      redis_id = Redis::HashKey.new("admin:" + current_user.id.to_s + ":session")

      unless redis_id['name'] == current_user.email
        redirect_to :root and return
      end

      if redis_id['auth'].nil? || !JSON.parse(redis_id['auth']).include?("download_edm_users")
        redirect_to :root and return
      end

    end

end

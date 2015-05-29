class Api::User::ConfirmationsController < Api::Base
  def create

    user = User.send_confirmation_instructions(email: valid_params[:email], 'Content-Transfer-Encoding' => 'UTF-8')
    return render json: {result: 'success'} if user.errors.empty?
    return render json: {code: 002, description: 'E-mail ' + user.errors[:email].first} unless user.errors[:email].empty?
    render json: {code: 001, description: 'E-mail not found.'}
  end

  private 
    def valid_params
      params.permit(:email)
    end
end
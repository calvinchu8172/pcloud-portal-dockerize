class Api::Console::V1::Oauth2::ApplicationsController < Api::Base

  def index
    @apps = Doorkeeper::Application.all
    render json: {
      code: "0000",
      message: "OK",
      data: @apps
    }, status: 200
  end

  def show
    @app = Doorkeeper::Application.find_by_uid(params[:client_id])
    render json: {
      code: "0000",
      message: "OK",
      data: @app
    }, status: 200
  end

  def create
    @app = Doorkeeper::Application.new
    @app.name = params[:name]
    @app.scopes = params[:scopes] if params[:scopes]
    @app.redirect_uri = params[:redirect_uri]
    @app.logout_redirect_uri = params[:logout_redirect_uri]
    @app.save
    render json: {
      code: "0000",
      message: "OK",
      data: @app
    }, status: 200
  end

  def update
    @app = Doorkeeper::Application.find_by_uid(params[:client_id])
    @app.update_attributes(application_params)
    render json: {
      code: "0000",
      message: "OK",
      data: @app
    }, status: 200
  end

  def destroy
    @app = Doorkeeper::Application.find_by_uid(params[:client_id])
    @app.destroy
    render json: {
      code: "0000",
      message: "OK"
    }, status: 200
  end

  private

  def application_params
    params.permit(:name, :redirect_uri, :scopes, :logout_redirect_uri)
  end

end
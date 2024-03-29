class V2::Admin::AuthenticationController < ApplicationController
  skip_before_action :authenticate!
 
  def authenticate
    command = AuthenticateAdminUser.call(params[:username], params[:password])
 
    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
 end

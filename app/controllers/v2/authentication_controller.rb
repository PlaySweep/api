class V2::AuthenticationController < ApplicationController
  skip_before_action :authenticate!
 
  def authenticate
    command = AuthenticateUser.call(params[:phone_number])
 
    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
 end
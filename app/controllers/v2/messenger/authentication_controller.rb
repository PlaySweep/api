class V2::Messenger::AuthenticationController < ApplicationController
  skip_before_action :authenticate!
 
  def authenticate
    command = AuthenticateMessengerUser.call(params[:facebook_uuid])
 
    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
 end
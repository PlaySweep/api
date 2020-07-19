class V2::Messenger::UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    WelcomeBackJob.perform_later(@user.id) if params[:onboard]
    if @user
      respond_with @user
    else
      render json: { user: [] }
    end
  end
end
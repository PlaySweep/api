class V2::Messenger::UsersController < ApplicationController
  respond_to :json
  skip_before_action :authenticate!

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    if @user
      WelcomeBackJob.perform_later(@user.id) if params[:onboard]
      respond_with @user
    else
      render json: { user: [] }
    end
  end
end
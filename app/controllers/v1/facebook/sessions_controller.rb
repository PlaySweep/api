class V1::Facebook::SessionsController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!, only: :show

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    WelcomeBackJob.perform_later(@user.id) if params[:onboard]
    respond_with @user
  end

end
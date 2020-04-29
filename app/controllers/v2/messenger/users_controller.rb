class V2::Messenger::UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    render json: { user: [] } if @user.nil?

    respond_with @user
  end

end
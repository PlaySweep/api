class V1::UsersController < ApplicationController
  respond_to :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    session[:facebook_uuid] = params[:facebook_uuid] and respond_with @user
  end

  def create
    @user = User.create(user_params)
    session[:facebook_uuid] = @user.facebook_uuid
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name)
  end
end
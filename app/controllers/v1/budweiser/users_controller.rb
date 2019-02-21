class V1::Budweiser::UsersController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!, only: :create
  after_action :set_preference, only: :create, if: -> { params[:owner_id] }

  def index
    @users = BudweiserUser.all
    respond_with @users
  end

  def show
    @user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    respond_with @user
  end

  def create
    @user = BudweiserUser.create(user_params)
    respond_with @user
  end

  def update
    @user = current_user.update_attributes(user_params)
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :confirmed)
  end

  def set_preference
    user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    BudweiserPreference.create(user_id: user.id, owner_id: params[:owner_id])
  end
end
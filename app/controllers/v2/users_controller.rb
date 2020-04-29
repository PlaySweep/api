class V2::UsersController < ApplicationController
  respond_to :json
  before_action :set_user, only: [ :show, :update ]
  skip_before_action :authenticate!, only: [ :create ]

  def show
    respond_with @user
  end

  def create
    @user = User.new(user_params)
    service_result = CreateNewUser.call(@user, params)

    if service_result.success?
      respond_with @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    @user.update_attributes(user_params)
    service_result = UpdateUser.call(@user, params)

    if service_result.success?
      respond_with @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def data_params
    return params[:user][:data] if params[:user][:data].nil?
    JSON.parse(params[:user][:data].to_json)
  end

  def user_params
    params.require(:user)
      .permit(
        :facebook_uuid, :active, :first_name, :last_name, 
        :locale, :profile_pic, :timezone, :email, 
        :dob, :phone_number, :zipcode, :confirmed, 
        :locked, :gender, :source
      ).merge(data: data_params)
  end
end
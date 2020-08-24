class V2::UsersController < ApplicationController
  respond_to :json
  skip_before_action :authenticate!, only: [ :create ]

  def show
    @user = User.find(params[:id])
    fresh_when last_modified: @user.updated_at, public: true
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
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    service_result = UpdateUser.call(@user, params)

    if service_result.success?
      respond_with @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user)
      .permit(
        :facebook_uuid, :active, :first_name, :last_name, 
        :locale, :profile_pic, :timezone, :email, 
        :dob, :zipcode, :confirmed, 
        :locked, :gender, :source,
        :email_reminder, :email_recap, :sms_reminder
      )
  end
end
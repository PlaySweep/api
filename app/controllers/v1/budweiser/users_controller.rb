class V1::Budweiser::UsersController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!, only: :create

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
    if @user
      BudweiserPreference.create(user_id: @user.id)
    end
    respond_with @user
  end

  def update
    #TODO refactor actual teams and ids properly for production
    @user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    if @user.preference.owner_id
      ConfirmAccountNotificationJob.perform_later(@user.id)
    else
      PromptTeamSelectionJob.perform_later(@user.id)
    end
    respond_with @user
  end

  def send_slate_confirmation
    @user = BudweiserUser.find_by(facebook_uuid: params[:user_facebook_uuid])
    FacebookMessaging::Standard.deliver(@user, "Congratulations on completing your first Budweiser Sweep Card #{@user.first_name}! We’ll keep you updated on your status as the morning after the game rolls around 🌤", "SILENT_PUSH") if @user
    FacebookMessaging::Standard.deliver(@user, "Also, from now on, you can simply ask me to do things and I'll respond accordingly - for example: \n\n- I'd like to invite some friends  (but remember they need to be 21+ 😉)\n- What's my status?\n- Any more games available?", "SILENT_PUSH") if @user
    FacebookMessaging::Standard.deliver(@user, "You can even ask me for a list of my commands if you ever feel the need. You'll see that I'm pretty smart 😎", "SILENT_PUSH") if @user
    @user.preference.update_attributes(slate_messaging: false)
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed)
  end
end
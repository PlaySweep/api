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
      BudweiserPreference.create(user_id: @user.id, owner_id: 1)
    end
    respond_with @user
  end

  def update
    @user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    message = 
    FacebookMessaging::Standard.deliver(@user, "Thanks! You’ll never have to do that again, #{@user.first_name}!", "SILENT_PUSH")
    FacebookMessaging::Standard.deliver(@user, "So here's how it works: \n1. I’ll send you 3 questions for every time the Cardinals are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉", "SILENT_PUSH")
    FacebookMessaging::TextButton.deliver(@user, "Play Now ⚾️", "Tap below to get started 👇", "SILENT_PUSH")
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
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :confirmed)
  end
end
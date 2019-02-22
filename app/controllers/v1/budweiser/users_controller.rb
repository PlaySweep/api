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
    @user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    message = 
    FacebookMessaging::Standard.deliver(@user, "Thanks! You’ll never have to do that again, #{@user.first_name}!", "SILENT_PUSH")
    FacebookMessaging::Standard.deliver(@user, "So here's how it works: \n1. I’ll send you 3 questions every day the Mets are on the field 🙌\n2. Guess the outcome of all 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a raffle every single day to win prizes 🎟\n4. Get notified when you win 🎉", "SILENT_PUSH")
    FacebookMessaging::TextButton.deliver(@user, "Play Now ⚾️", "Tap below to get started 👇", "SILENT_PUSH")
    respond_with @user
  end

  def send_slate_confirmation
    @user = BudweiserUser.find_by(facebook_uuid: params[:user_facebook_uuid])
    FacebookMessaging::Standard.deliver(@user, "Your picks are in #{@user.first_name}! We’ll let you know how you did as soon as the morning after the game rolls around 🌤", "SILENT_PUSH") if @user
    @user.preference.update_attributes(slate_messaging: false) unless @user.slates.size > 1
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
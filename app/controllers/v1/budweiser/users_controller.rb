class V1::Budweiser::UsersController < BudweiserController
  respond_to :json

  skip_before_action :authenticate!, only: :create

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    respond_with @user
  end

  def create
    @user = User.create(user_params)
    if @user
      Preference.create(user_id: @user.id)
      increment_entries_for_referrer if params[:referrer_uuid] 
    end
    respond_with @user
  end

  def update
    #TODO refactor this method so it doesnt run every time the user gets updated
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    unless @user.locked
      if @user.preference.owner_id
        ConfirmAccountNotificationJob.perform_later(@user.id)
      else
        PromptTeamSelectionJob.perform_later(@user.id)
      end
    end
    respond_with @user
  end

  private

  def increment_entries_for_referrer
    User.find_by(facebook_uuid: params[:referrer_uuid]).entries.create!
  end

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked, :gender, :referral)
  end
end
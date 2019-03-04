class V1::Budweiser::UsersController < BudweiserController
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
    #TODO refactor this method so it doesnt run every time the user gets updated
    @user = BudweiserUser.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    if @user.preference.owner_id
      ConfirmAccountNotificationJob.perform_later(@user.id)
    else
      PromptTeamSelectionJob.perform_later(@user.id)
    end
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked)
  end
end
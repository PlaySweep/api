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
    if @user.save
      increment_entries_for_referrer if params[:referrer_uuid]
      @user.add_role(:washington_nationals, Team.find_by(name: "Washington Nationals"))
    end
    respond_with @user
  end

  def update
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    handle_confirmation if params[:confirmation] and !@user.locked
    respond_with @user
  end

  private

  def increment_entries_for_referrer
    User.find_by(facebook_uuid: params[:referrer_uuid]).entries.create!
  end

  def set_team_role
    @user.add_role(params[:team].downcase.split(' ').join('_').to_sym, Team.find_by(name: params[:team]))
  end

  def handle_confirmation
    if @user.roles.where(resource_type: "Team").blank?
      PromptTeamSelectionJob.perform_later(@user.id)
    else
      @user.add_role(:confirmed_user)
      ConfirmAccountNotificationJob.perform_later(@user.id)
    end
  end

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked, :gender, :referral)
  end
end
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
      @user.add_role(params[:team].downcase.split(' ').join('_').to_sym, Team.find_by(name: params[:team])) if params[:team]
    end
    respond_with @user
  end

  def update
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    @user.update_attributes(user_params)
    handle_confirmation if params[:confirmation] and !@user.locked
    @user.add_role(params[:team].downcase.split(' ').join('_').to_sym, Team.find_by(name: params[:team])) if params[:team]
    respond_with @user
  end

  private

  def increment_entries_for_referrer
    User.find_by(facebook_uuid: params[:referrer_uuid]).entries.create!
  end

  def handle_confirmation
    if @user.roles.where(resource_type: "Team").blank?
      PromptTeamSelectionJob.perform_later(@user.id)
    else
      @user.add_role(:confirmed_user)
      ConfirmAccountNotificationJob.perform_later(@user.id)
    end
  end

  def data_params
    return params[:user][:data] if params[:user][:data].nil?
    JSON.parse(params[:user][:data].to_json)
  end

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked, :gender, :referral).merge(data: data_params)
  end
end
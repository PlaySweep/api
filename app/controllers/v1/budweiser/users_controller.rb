class V1::Budweiser::UsersController < BudweiserController
  respond_to :json

  skip_before_action :authenticate!, only: :create

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = current_user
    respond_with @user
  end

  def create
    @user = User.create(user_params)
    if @user.save
      increment_entries_for_referrer if params[:referrer_uuid]
      if params[:team]
        team = Team.by_name(params[:team]).first
        add_role
        subscribe_to(resource: team, user: @user)
      end
    end
    respond_with @user
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    handle_confirmation if params[:confirmation] and !@user.locked
    if params[:team]
      team = Team.by_name(params[:team]).first

      remove_role
      unsubscribe(user: @user)

      add_role
      subscribe_to(resource: team, user: @user)
    end
    respond_with @user
  end

  private

  def increment_entries_for_referrer
    referrer = User.find_by(facebook_uuid: params[:referrer_uuid]).entries.create!
  end

  def handle_confirmation
    if @user.roles.where(resource_type: "Team").blank?
      PromptTeamSelectionJob.perform_later(@user.id)
    else
      @user.add_role(:confirmed_user)
      ConfirmAccountNotificationJob.perform_later(@user.id)
    end
  end

  def add_role
    team = Team.by_name(params[:team]).first
    symbolized_role = team.name.downcase.split(' ').join('_').to_sym
    @user.add_role(symbolized_role, team)
  end

  def remove_role
    symbolized_role = @user.roles.find_by(resource_type: "Team").resource.name.downcase.split(' ').join('_').to_sym
    team = @user.roles.find_by(resource_type: "Team").resource
    @user.remove_role(symbolized_role, team)
  end

  def subscribe_to resource:, user:
    FacebookMessaging::Broadcast.subscribe(resource: resource, user: user)
  end

  def unsubscribe user:
    FacebookMessaging::Broadcast.unsubscribe(user: user)
  end

  def data_params
    return params[:user][:data] if params[:user][:data].nil?
    JSON.parse(params[:user][:data].to_json)
  end

  def user_params
    params.require(:user).permit(:facebook_uuid, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked, :gender, :referral).merge(data: data_params)
  end
end
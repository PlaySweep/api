class V1::UsersController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!, only: :create

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = current_user
    WelcomeBackJob.perform_later(@user.id) if @user and params[:onboard]
    respond_with @user
  end

  def create
    @user = User.new(user_params)
    @user.account_id = current_account.id
    if @user.save
      increment_entries_for_referrer if params[:referrer_uuid]
      if params[:team]
        team = Team.by_name(params[:team]).first
        add_role if team
        # subscribe_to(resource: team, user: @user)
      end
      WelcomeJob.perform_later(@user.id) if params[:onboard]
    end
    respond_with @user
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    handle_confirmation if params[:confirmation] and !@user.locked
    if params[:team]
      team = Team.by_name(params[:team]).first
      if team
        unsubscribe(user: @user)
        remove_role

        add_role
        subscribe_to(resource: team, user: @user)
      end
    end
    unsubscribe(user: @user) if params[:unsubscribe]
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
      ConfirmAccountNotificationJob.perform_later(@user.id)
    end
  end

  def add_role
    team = Team.by_name(params[:team]).first
    symbolized_role = team.name.downcase.split(' ').join('_').to_sym
    @user.add_role(symbolized_role, team)
  end

  def remove_role
    previous_role = @user.roles.find_by(resource_type: "Team")
    if previous_role.present?
      symbolized_role = previous_role.resource.name.downcase.split(' ').join('_').to_sym
      previous_team = previous_role.resource
      @user.remove_role(symbolized_role, previous_team)
    end
  end

  def subscribe_to resource:, user:
    FacebookMessaging::Broadcast.subscribe(resource: resource, user: user)
  end

  def unsubscribe user:
    FacebookMessaging::Broadcast.unsubscribe(user: user)
  end

  def shipping_params
    return params[:user][:shipping] if params[:user][:shipping].nil?
    JSON.parse(params[:user][:shipping].to_json)
  end

  def data_params
    return params[:user][:data] if params[:user][:data].nil?
    JSON.parse(params[:user][:data].to_json)
  end

  def user_params
    params.require(:user).permit(:facebook_uuid, :active, :first_name, :last_name, :locale, :profile_pic, :timezone, :email, :dob, :zipcode, :confirmed, :locked, :gender, :referral).merge(data: data_params).merge(shipping: shipping_params)
  end
end
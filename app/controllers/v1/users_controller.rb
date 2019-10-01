class V1::UsersController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!, only: [:create]

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by(id: params[:id])
    respond_with @user
  end

  def fetch_by_slug
    @user = User.find_by(slug: params[:slug])
    respond_with @user
  end

  def by_referral_code
    @user = User.find_by(referral_code: params[:referral_code])
    respond_with @user
  end

  def create
    @user = User.new(user_params)
    @user.account_id = current_account.id
    if params[:referral_code]
      referred_by_id = User.find_by(referral_code: params[:referral_code]).id
      @user.referred_by_id = referred_by_id
    end
    if @user.save
      # IndicativeTrackEventNewUserJob.perform_later(@user.id)
      if params[:team]
        team = Team.by_name(params[:team]).first
        add_role if team
        subscribe_to(resource: team, user: @user)
      end
      WelcomeJob.perform_later(@user.id) if params[:onboard]
      respond_with @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update_attributes(user_params)
    if @user.save
      # IndicativeTrackEventConfirmedAccountJob.perform_later(@user.id) if params[:confirmation]
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
    end
    respond_with @user
  end

  def reset
    @user = User.find_by(id: params[:id])
    @user.has_recently_won.set(nil)
    respond_with @user
  end

  private

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
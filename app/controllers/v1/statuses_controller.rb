class V1::StatusesController < ApplicationController
  respond_to :json

  skip_before_action :authenticate!

  def index
    @users = User.active.top_streak(limit: params[:limit])
    respond_with @users
  end

  def show
    @user = current_user
    respond_with  @user
  end
end
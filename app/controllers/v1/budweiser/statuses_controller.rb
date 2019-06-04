class V1::Budweiser::StatusesController < BudweiserController
  respond_to :json

  skip_before_action :authenticate!

  def index
    @users = User.active.top_streak(limit: params[:limit])
    respond_with @users
  end

  def show
    @user = User.find_by(facebook_uuid: params[:facebook_uuid])
    respond_with  @user
  end
end
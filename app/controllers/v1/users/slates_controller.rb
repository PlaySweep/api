class V1::Users::SlatesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @slates = @user.slates.started.descending if params[:started]
    @slates = @user.slates.finished.since_last_week.descending if params[:finished]
    respond_with @slates
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @slate = @user.slates.find_by(id: params[:id])
    if @slate
      respond_with @slate
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

end
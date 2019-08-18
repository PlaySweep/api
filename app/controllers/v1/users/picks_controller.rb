class V1::Users::PicksController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @picks = @user.picks.for_slate(params[:slate_id])
    respond_with @picks
  end

  def show
    user = User.find_by(id: params[:user_id])
    @pick = user.picks.find_by(id: params[:id])
    if @pick
      respond_with @pick
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def create
    #TODO send user_id
    @pick = Pick.create(pick_params)
    if @pick.save
      respond_with @pick
    else
      render json: { errors: @pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    #TODO send user_id
    @pick = Pick.find(params[:id])
    @pick.update_attributes(pick_params)
    if @pick.save
      respond_with @pick
    else
      render json: { errors: @pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def pick_params
    params.require(:pick).permit(:user_id, :selection_id, :event_id)
  end
end
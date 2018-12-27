class V1::PicksController < ApplicationController
  respond_to :json

  def show
    @pick = current_user.picks.find_by(id: params[:id])
    if @pick
      respond_with @pick
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def create
    @pick = current_user.picks.create(pick_params)
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
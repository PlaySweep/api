class V1::PicksController < ApplicationController
  respond_to :json

  def show
    @pick = Pick.find(params[:id])
    respond_with @pick
  end

  def create
    @pick = Pick.create(pick_params)
    respond_with @pick
  end

  private

  def pick_params
    params.require(:pick).permit(:user_id, :selection_id, :event_id)
  end
end
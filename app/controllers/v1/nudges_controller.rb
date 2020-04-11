class V1::NudgesController < ApplicationController
  respond_to :json

  def create
    @nudge = Nudge.create(nudge_params)
    if @nudge.save
      respond_with @nudge
    else
      render json: { errors: @nudge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def nudge_params
    params.require(:nudge).permit(:nudger_id, :nudged_id, :started, :status)
  end
end
class Budweiser::V1::SlatesController < ApplicationController
  respond_to :json

  def index
    @slates = BudweiserSlate.for_owner(current_user.preference.owner_id).pending
    respond_with @slates
  end

  def show
    @slate = Slate.find_by(id: params[:id])
    if @slate
      respond_with @slate
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end
end
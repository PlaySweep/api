class V2::SlatesController < ApplicationController
  respond_to :json

  def index
    if current_user
      @slates = Slate.unfiltered.or(Slate.filtered(current_user.filtered_ids)).ascending.available
      # fresh_when last_modified: @slates.maximum(:updated_at), public: true
      respond_with @slates
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def show
    @slate = Slate.find_by(id: params[:id])
    if @slate
      fresh_when last_modified: @slate.updated_at, public: true
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def update
    @slate = Slate.find_by(id: params[:id])
    @slate.update_attributes(slate_params)
    if @slate
      respond_with @slate
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  private

  def slate_params
    params.require(:slate).permit(:status)
  end
end
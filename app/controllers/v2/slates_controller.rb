class V2::SlatesController < ApplicationController
  respond_to :json

  def index
    user = User.find_by(id: params[:user_id])
    if user
      @slates = Slate.unfiltered.or(Slate.filtered(user.filtered_ids)).ascending.available
      @slates = Slate.unfiltered.or(Slate.filtered(user.filtered_ids)).ascending.inactive if params[:inactive]
      respond_with @slates
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def show
    @slate = Slate.find_by(id: params[:id])
    if @slate
      respond_with @slate
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
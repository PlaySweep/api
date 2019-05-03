class V1::Budweiser::Users::SlatesController < BudweiserController
  respond_to :json

  def index
    @slates = current_user.slates.since_last_week.descending
    respond_with @slates
  end

  def show
    @slate = current_user.slates.find_by(id: params[:id])
    if @slate
      respond_with @slate
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end
end
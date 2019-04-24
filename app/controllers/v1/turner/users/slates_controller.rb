class V1::Turner::Users::SlatesController < TurnerController
  respond_to :json

  def index
    @slates = current_user.slates.ascending.available
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
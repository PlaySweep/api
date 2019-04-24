class V1::Turner::SlatesController < TurnerController
  respond_to :json

  def index
    @slates = Slate.filtered(current_user.roles.map(&:resource_id)).ascending.available
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
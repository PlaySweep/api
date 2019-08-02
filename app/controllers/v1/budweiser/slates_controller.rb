class V1::Budweiser::SlatesController < BudweiserController
  respond_to :json

  def index
    @slates = Slate.filtered(current_user.roles.map(&:resource_id)).or(Slate.unfiltered).ascending.pending
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
class V1::Budweiser::SlatesController < BudweiserController
  respond_to :json

  def index
    @slates = BudweiserSlate.for_owner(current_user.preference.owner_id).available
    respond_with @slates
  end

  def show
    @slate = BudweiserSlate.find_by(id: params[:id])
    if @slate
      respond_with @slate
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end
end
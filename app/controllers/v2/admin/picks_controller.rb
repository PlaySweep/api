class V2::Admin::PicksController < BasicAuthenticationController
  respond_to :json

  def update
    @pick = Pick.find(params[:id])
    @pick.update_attributes(pick_params)
    respond_with @pick
  end

  private

  def pick_params
    params.require(:pick).permit(:id, :status)
  end
end
class V2::Admin::PicksController < BasicAuthenticationController
  respond_to :json

  def update
    @pick = Pick.find(params[:id])
    @pick.update_attributes(event_params)
    respond_with @pick
  end

  private

  def event_params
    params.require(:event).permit(:id, :status)
  end
end
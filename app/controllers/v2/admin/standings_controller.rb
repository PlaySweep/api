class V2::Admin::StandingsController < BasicAuthenticationController
  respond_to :json

  def index
    @standings = Standing.ordered
    respond_with @standings
  end

  def show
    @standing = Standing.find(params[:id])
    respond_with @standing
  end

  def update
    @standing = Standing.find(params[:id])
    @standing.update_attributes(standing_params)
    respond_with @standing
  end

  private

  def standing_params
    params.require(:standing).permit(:id, :records, :position)
  end
end
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
end
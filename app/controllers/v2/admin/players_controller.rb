class V2::Admin::PlayersController < BasicAuthenticationController
  respond_to :json

  def show
    @player = Player.find(params[:id])
    respond_with @player
  end
end
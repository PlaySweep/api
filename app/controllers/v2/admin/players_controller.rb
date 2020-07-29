class V2::Admin::PlayersController < BasicAuthenticationController
  respond_to :json

  def index
    @players = Player.all
    respond_with @players
  end

  def show
    @player = Player.find(params[:id])
    respond_with @player
  end
end
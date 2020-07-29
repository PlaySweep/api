class V2::Admin::PlayersController < BasicAuthenticationController
  respond_to :json

  def index
    @players = Player.recent
    @players = @players.where(participant_id: params[:participant_id]) if params[:participant_id]
    respond_with @players
  end

  def show
    @player = Player.find(params[:id])
    respond_with @player
  end
end
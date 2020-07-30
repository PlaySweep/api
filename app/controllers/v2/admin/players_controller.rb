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

  def create
    @player = Player.create(player_params)
    if @player.save
      respond_with @player
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:id, :participant_id, :profile_id)
  end
end
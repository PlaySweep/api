class V2::Admin::PlayersController < ApplicationController
  respond_to :json

  def show
    @player = Player.find(params[:id])
    respond_with @player
  end
end
class V2::LeaderboardsController < ApplicationController
  respond_to :json

  def show
    @leaderboard = current_user.account.active_leaderboard
    if @leaderboard
      respond_with @leaderboard
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end
end
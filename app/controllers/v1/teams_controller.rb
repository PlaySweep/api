class V1::TeamsController < ApplicationController
  respond_to :json

  def index
    @teams = Team.active.ordered
    @teams = Team.active.ordered.by_division(params[:division]) if params[:division]
    respond_with @teams
  end

end
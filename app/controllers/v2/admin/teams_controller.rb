class V2::Admin::TeamsController < ApplicationController
  respond_to :json

  def index
    @teams = Team.ordered
    @teams = @teams.sponsored if params[:sponsored]
    @teams = @teams.active if params[:active]
    @teams = @teams.active.by_name(params[:team]) if params[:team]
    respond_with @teams
  end

  def show
    @team = Team.find(params[:id])
    respond_with @team
  end
end
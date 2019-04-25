class Admin::TeamsController < AdminController
  respond_to :json

  def index
    @teams = Team.ordered
    @teams = @teams.sponsored if params[:sponsored]
    @teams = @teams.active if params[:active]
    respond_with @teams
  end

  def show
    @team = Team.find(params[:id])
    respond_with @team
  end
end
class Admin::TeamsController < AdminController
  respond_to :json

  def index
    @teams = Team.ordered.sponsored
    respond_with @teams
  end

  def show
    @team = Team.find(params[:id])
    respond_with @team
  end
end
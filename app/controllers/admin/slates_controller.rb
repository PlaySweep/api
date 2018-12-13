class Admin::SlatesController < ApplicationController
  respond_to :json

  def index
    team = Team.find(params[:team_id])
    @slates = team.slates.pending
    respond_with @slates
  end

  def show
    team = Team.find(params[:team_id])
    @slate = team.slates.pending.find(params[:id])
    respond_with @slate
  end
end
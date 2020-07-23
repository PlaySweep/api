class V2::Admin::TeamsController < ApplicationController
  respond_to :json
  skip_before_action :authenticate!
  
  def index
    @teams = Team.active.ordered
    respond_with @teams
  end
end
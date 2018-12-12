class V1::TeamsController < ApplicationController
  def index
    @teams = Team.all
  end
end
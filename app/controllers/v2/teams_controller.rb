class V2::TeamsController < ApplicationController
  respond_to :json

  def index
    @teams = Team.active.ordered
    @teams = Team.active.ordered.by_division(params[:division]) if params[:division]
    @teams = recommended_team_ids.collect { |id| Team.find(id) } if params[:recommended_teams]
    respond_with @teams
  end

  private

  def recommended_team_ids
    user = User.find_by(id: params[:user_id])
    teams_with_distance = Team.active.map do |team|
      { id: team.id, name: team.name, abbreviation: team.abbreviation, image: team.image, distance: Haversine.distance(team.coordinates, user.coordinates).to_miles }
    end
    teams_with_distance.sort_by { |team| team[:distance] }.first(3).map(&:to_dot).map(&:id)
  end

end
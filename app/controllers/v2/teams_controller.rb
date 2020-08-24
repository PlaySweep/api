class V2::TeamsController < ApplicationController
  respond_to :json

  def index
    if params[:recommended_teams]
      @teams = recommended_team_ids.collect { |id| Team.find(id) }
      respond_with @teams
    end
    @teams = Team.active.ordered
    fresh_when last_modified: @teams.maximum(:updated_at), public: true
  end

  private

  def recommended_team_ids
    user = User.find_by(id: params[:user_id])
    teams_with_distance = Team.active.map do |team|
      { id: team.id, name: team.name, abbreviation: team.abbreviation, initials: team.initials, image: team.image, distance: Haversine.distance(team.coordinates, user.coordinates).to_miles }
    end
    teams_with_distance.sort_by { |team| team[:distance] }.map(&:to_dot).map(&:id)
  end

end
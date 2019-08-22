class PromptTeamSelectionJob < ApplicationJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = User.find(user_id)
    available_teams = []
    radius = 300
    coordinates = Geocoder.search(user.zipcode.to_i).first.coordinates
    if coordinates
      while available_teams.size < 3
        Team.active.each do |team|
          distance = Haversine.distance(coordinates.first, coordinates.second, team.lat.to_f, team.long.to_f).to_miles
          available_teams.push(team) if distance < radius and !available_teams.include?(team)
          break if available_teams.size == 3
        end
        radius *= 3
      end
      url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/teams/initial_load"
      text = "We found a few teams close by to choose from...\n\nIf you don't already see the team you want - you can view the rest below 👇"
      quick_replies = available_teams.map do |team|
        {
          "content_type": "text",
          "title": team.abbreviation,
          "payload":"#{team.name}_#{team.id}",
        }
      end
      FacebookMessaging::TextButton.deliver(user, "More Teams", text, "SILENT_PUSH", url, quick_replies)
    end
    
  end
end
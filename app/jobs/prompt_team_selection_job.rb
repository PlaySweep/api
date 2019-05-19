class PromptTeamSelectionJob < BudweiserJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = User.find(user_id)
    available_teams = []
    radius = 300
    coordinates = Geocoder.search(user.zipcode.to_i).first.coordinates
    if coordinates
      Team.active.each do |team|
        distance = Haversine.distance(coordinates.first, coordinates.second, team.lat.to_f, team.long.to_f).to_miles
        available_teams.push(team) if distance < radius
        break if available_teams.size == 3
        radius *= 3
      end
      url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load"
      text = "Here's what I found...\n\nIf you don't see the team you want - we have more 👇"
      quick_replies = available_teams.map do |team|
        {
          "content_type": "text",
          "title": team.abbreviation,
          "payload":"#{team.name}_#{team.id}",
        }
      end
      FacebookMessaging::TextButton.deliver(user, "More Teams ⚾️", text, "SILENT_PUSH", url, quick_replies)
    end
  end
end
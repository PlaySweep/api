class PromptTeamSelectionJob < BudweiserJob
  @queue = :prompt_team_selection_job

  def perform user_id
    puts "ID found: #{user_id}"
    user = BudweiserUser.find(user_id)
    puts "User found: #{user.inspect}"
    available_teams = Team.ordered.sponsored
    puts "Available teams: #{available_teams.inspect}"
    quick_replies = available_teams.map do |team, i|
      {
        "content_type": "text",
        "title": team.name,
        "payload":"#{team.name}_#{team.id}",
      }
    end
    FacebookMessaging::QuickReply.deliver(user, "Got it, thanks #{user.first_name}! For Spring training, please select one of the available teams below to get started 👇", quick_replies, "SILENT_PUSH")
  end
end
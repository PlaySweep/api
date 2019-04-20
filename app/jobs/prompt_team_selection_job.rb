class PromptTeamSelectionJob < BudweiserJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = User.find(user_id)
    quick_replies = Team.ordered.sponsored.active.map do |team, i|
      {
        "content_type": "text",
        "title": team.abbreviation,
        "payload":"#{team.name}_#{team.id}",
      }
    end
    FacebookMessaging::QuickReply.deliver(user, "Got it, thanks #{user.first_name}! Please select one of the available teams below to get started 👇", quick_replies, "SILENT_PUSH")
  end
end
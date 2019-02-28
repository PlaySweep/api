class PromptTeamSelectionJob < ApplicationJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    available_teams = Team.all
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
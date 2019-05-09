class PromptTeamSelectionJob < BudweiserJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Got it, thanks #{user.first_name}! Give us a nearby city and I'll do a quick search to find what teams are available for you 👇", "SILENT_PUSH")
  end
end
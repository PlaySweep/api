class PromptTeamSelectionJob < ApplicationJob
  @queue = :prompt_team_selection_job

  def perform user_id
    user = User.find(user_id)
    url="#{ENV["WEBVIEW_URL"]}/#{user.id}/teams/initial_load"
    text = "We have a few teams to choose from - tap below to get started 👇"
    FacebookMessaging::TextButton.deliver(user, "More Teams", text, "SILENT_PUSH", url)
  end
end
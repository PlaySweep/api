class SendFirstSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Congratulations on answering all of the questions for your first Budweiser Sweep Contest, #{user.first_name}! You’ll be updated on your status as early as the morning after the game.", "SILENT_PUSH")
    FacebookMessaging::Standard.deliver(user, "From now on, you can simply ask things and you’ll get a quick response - for example: invite friends, what are my answers, more games, future contests, and much more.", "SILENT_PUSH")
  end
end
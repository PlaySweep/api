class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Your answers are in, #{user.first_name}!\n\nYou’ll get your results the morning after the game.", "SILENT_PUSH")
  end
end
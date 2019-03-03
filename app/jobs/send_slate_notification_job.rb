class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id, first_time_user
    user = BudweiserUser.find(user_id)
    if first_time_user
      FacebookMessaging::Standard.deliver(user, "Congratulations on answering all of the questions for your first Budweiser Sweep Contest, #{user.first_name}! You’ll be updated on your status as early as the morning after the game.", "SILENT_PUSH")
      FacebookMessaging::Standard.deliver(user, "From now on, you can simply ask things and you’ll get a quick response - for example: invite friends, what are my answers, more games, future contests, and much more.", "SILENT_PUSH")
    else
      FacebookMessaging::Standard.deliver(user, "Your answers are in, #{user.first_name}!\n\nYou’ll get your results the morning after the game.", "SILENT_PUSH")
    end
  end
end
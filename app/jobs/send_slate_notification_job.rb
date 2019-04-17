class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id
    user = User.find(user_id)
    if user.cards.size > 1
      FacebookMessaging::Standard.deliver(user, "Your answers are in, #{user.first_name}! You’ll get your results once the game has been completed.", "NO_PUSH")
    else
      FacebookMessaging::Standard.deliver(user, "Congratulations on answering all of the questions for your first Budweiser Sweep Contest, #{user.first_name}! You’ll be updated on your status as early as soon as the games are completed.", "NO_PUSH")
      FacebookMessaging::Standard.deliver(user, "From now on, you can simply ask things and you’ll get a quick response\n\nFor example, try typing invite friends, what are my answers, more games, future contests, and much more.", "NO_PUSH")
    end
  end
end
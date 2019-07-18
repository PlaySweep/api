class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if user.cards.size > 1
      FacebookMessaging::Standard.deliver(user, "Nice job #{user.first_name}, your answers are in 👍", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    else
      FacebookMessaging::Standard.deliver(user, "Congratulations #{user.first_name}, you completed your first Bud Light Sweep Contest!\n\nWe’ll notify you of your results when the games are complete - and when you start getting thirsty, here's a $5 Drizly credit that you can redeem right now 🍺!", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_drizly(user, "5")
    end
  end
end
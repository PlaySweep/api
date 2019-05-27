class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if user.cards.size > 1
      if slate.global
        FacebookMessaging::Standard.deliver(user, "Nice job #{user.first_name}, your answers for the All-Star Contest are in 👍", "NO_PUSH")
        FacebookMessaging::Carousel.deliver_global(user)
      else
        FacebookMessaging::Standard.deliver(user, "Nice job #{user.first_name}, your answers are in 👍", "NO_PUSH")
        FacebookMessaging::Carousel.deliver_team(user)
      end
    else
      FacebookMessaging::Standard.deliver(user, "Congratulations #{user.first_name}, you completed your first Budweiser Sweep Contest!\n\nWe’ll notify you of your results when the games are complete - so feel free to ask things like invite friends, more games, status, and much more in the meantime 👍", "NO_PUSH")
      if slate.global
        FacebookMessaging::Carousel.deliver_global(user)
      else
        FacebookMessaging::Carousel.deliver_team(user)
      end
    end
  end
end
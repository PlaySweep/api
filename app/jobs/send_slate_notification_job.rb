class SendSlateNotificationJob < BudweiserJob
  @queue = :send_slate_notification_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    if user.cards.size > 1
      FacebookMessaging::Standard.deliver(user, "Your answers are in, #{user.first_name}! You’ll get your results the morning after the game.", "SILENT_PUSH")
    else
      # FacebookMessaging::Standard.deliver(user, "Congratulations on answering all of the questions for your first Budweiser Sweep Contest, #{user.first_name}! You’ll be updated on your status as early as the morning after the game.", "SILENT_PUSH")
      # FacebookMessaging::Standard.deliver(user, "From now on, you can simply ask things and you’ll get a quick response\n\nFor example try invite friends, what are my answers, more games, future contests, and much more.", "SILENT_PUSH")
      FacebookMessaging::Standard.deliver(user, "Thanks! You’ll never have to do that again, #{user.first_name}!\n\nSo here's how it works: \n1. I’ll send you 3 questions for every time the Cardinals are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉", "SILENT_PUSH")
      FacebookMessaging::TextButton.deliver(user, "Play Now ⚾️", "Tap below to get started 👇", "SILENT_PUSH")
    end
  end
end
class ConfirmAccountNotificationJob < BudweiserJob
  @queue = :confirm_account_notification_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Thanks! You’ll never have to do that again, #{user.first_name}!\n\nSo here's how it works: \n1. I’ll send you 3 questions for every time the #{user.preference.team.name} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉", "SILENT_PUSH")
    FacebookMessaging::TextButton.deliver(user, "Play Now ⚾️", "Tap below to get started 👇", "SILENT_PUSH")
  end
end
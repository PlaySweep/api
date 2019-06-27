class ConfirmAccountNotificationJob < BudweiserJob
  @queue = :confirm_account_notification_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Thanks, #{user.first_name}! You’ll never have to do that again...\n\nSo here's how it works: \n1. I’ll send you 6 questions for every time the #{Team.find(user.roles.where(resource_type: "Team").first.resource_id).name} are on the field 🙌\n2. Answer 6 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single week to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🏈", "SILENT_PUSH")
    FacebookMessaging::Carousel.deliver_bud(user)
  end
end
class ConfirmAccountNotificationJob < ApplicationJob
  @queue = :confirm_account_notification_job

  def perform user_id
    user = User.find(user_id)
    role = user.roles.find_by(resource_type: "Team").resource
    copy = user.account.copies.where(category: "Account Confirmation").sample.message
    interpolated = copy % {first_name: user.first_name, team_abbreviation: role.abbreviation}
    FacebookMessaging::Standard.deliver(user, interpolated, "SILENT_PUSH")
    FacebookMessaging::Carousel.deliver_team(user)
  end
end
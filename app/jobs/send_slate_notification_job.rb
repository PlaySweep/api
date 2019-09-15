class SendSlateNotificationJob < ApplicationJob
  @queue = :send_slate_notification_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    pick_confirmation_copy = user.account.copies.where(category: "Pick Confirmation").sample.message
    pick_confirmation_interpolated = pick_confirmation_copy % { first_name: user.first_name }
    if user.cards.size > 1
      FacebookMessaging::Standard.deliver(
        user: user,
        message: pick_confirmation_interpolated,
        notification_type: "NO_PUSH"
      )
      if user.current_team
        attachment_id = user.current_team.medias.find_by(category: "Slate Notification").try(:attachment_id)
        FacebookMessaging::MediaAttachment.deliver(
          user: user, attachment_id: attachment_id
        ) if attachment_id
      end
      FacebookMessaging::Generic::Contest.deliver(user: user)
    else
      initial_pick_confirmation_copy = user.account.copies.where(category: "Initial Pick Confirmation").sample.message
      initial_pick_confirmation_interpolated = initial_pick_confirmation_copy % { first_name: user.first_name }
      FacebookMessaging::Standard.deliver(
        user: user,
        message: initial_pick_confirmation_interpolated,
        notification_type: "NO_PUSH"
      )
      if user.current_team
        attachment_id = user.current_team.medias.find_by(category: "Slate Notification").try(:attachment_id)
        FacebookMessaging::MediaAttachment.deliver(
          user: user, attachment_id: attachment_id
        ) if attachment_id
      end
      FacebookMessaging::Generic::Contest.deliver(user: user)
    end
  end
end
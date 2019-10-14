class SendSlateNotificationJob < ApplicationJob
  queue_as :high

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if user.played_for_first_time?
      quick_replies = FacebookParser::QuickReplyObject.new([
        {
          content_type: :text,
          title: "Status",
          payload: "STATUS"
        },
        { content_type: :text,
          title: "Play again",
          payload: "PLAY",
          image_url: user.current_team.image
        },
        {
          content_type: :text,
          title: "Share",
          payload: "SHARE"
        }
      ]).objects
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
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    end
  end
end
class SendSlateNotificationWithDrizlyJob < ApplicationJob
  @queue = :send_slate_notification_with_drizly_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    promotion = user.promotions.find_by(type: "DrizlyPromotion", category: "Playing", slate_id: slate.id)
    initial_drizly_pick_confirmation_copy = user.account.copies.where(category: "Drizly Initial Pick Confirmation").sample.message
    initial_drizly_pick_confirmation_interpolated = initial_drizly_pick_confirmation_copy % { first_name: user.first_name, drizly_value: promotion.value_in_format }
    image = user.account.medias.find_by(category: "Drizly Lockup")
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      },
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      },
      {
        content_type: :text,
        title: "Celebrate!",
        payload: "CELEBRATE"
      }
    ]).objects
    FacebookMessaging::MediaAttachment.deliver(user: user, attachment_id: image.attachment_id)
    FacebookMessaging::Standard.deliver(
      user: user,
      message: initial_drizly_pick_confirmation_interpolated,
      notification_type: "NO_PUSH"
    )
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  end
end
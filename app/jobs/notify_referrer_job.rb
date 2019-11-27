class NotifyReferrerJob < ApplicationJob
  queue_as :low

  def perform user_id, referred_id, reason
    user = User.find(user_id)
    referred_user = User.find(referred_id)
    case reason
    when User::SWEEP
      referrer_notification_copy = user.account.copies.where(category: "Notify Sweep Referral").sample.message
      referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.abbreviated_name }
    else
      referrer_notification_copy = user.account.copies.where(category: "Notify Referral").sample.message
      referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.abbreviated_name }
    end
    quick_replies = FacebookParser::QuickReplyObject.new([
      { content_type: :text,
        title: "Play now",
        payload: "PLAY",
        image_url: user.current_team.image
      },
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      }
    ]).objects
    FacebookMessaging::Standard.deliver(
      user: user,
      message: referrer_notification_copy_interpolated,
      quick_replies: quick_replies,
      notification_type: "SILENT_PUSH"
    )
  end
end
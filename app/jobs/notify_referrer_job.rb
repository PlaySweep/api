class NotifyReferrerJob < ApplicationJob
  queue_as :low

  def perform referrer_id, referred_id
    referrer = User.find(referrer_id)
    referred_user = User.find(referred_id)
    referrer_notification_copy = referrer.account.copies.where(category: "Notify Referral").sample.message
    referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.abbreviated_name, referral_count: referrer.active_referrals.completed.size }
    quick_replies = FacebookParser::QuickReplyObject.new([
      { content_type: :text,
        title: "Play now",
        payload: "PLAY",
        image_url: referrer.current_team.image
      },
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      }
    ]).objects
    FacebookMessaging::Standard.deliver(
      user: referrer,
      message: referrer_notification_copy_interpolated,
      quick_replies: quick_replies,
      notification_type: "SILENT_PUSH"
    )
  end
end
class NotifyReferrerJob < ApplicationJob
  @queue = :notify_referrer_job

  def perform user_id, referred_id, reason
    user = User.find(user_id)
    referred_user = User.find(referred_id)
    case reason
    when "playing"
      referrer_notification_copy = user.account.copies.where(category: "Notify Playing Referral").sample.message
      referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.first_name, entry_count: user.entries.unused.count, entry_syntax: user.entries.unused.count == 1 ? "entry" : "entries" }
    when "sweep"
      referrer_notification_copy = user.account.copies.where(category: "Notify Sweep Referral").sample.message
      referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.first_name, earned_entry_count: 2 }
    else
      referrer_notification_copy = user.account.copies.where(category: "Notify Referral").sample.message
      referrer_notification_copy_interpolated = referrer_notification_copy % { referred_name: referred_user.first_name, entry_count: user.entries.unused.count, earned_entry_count: 1 }
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
      },
      {
        content_type: :text,
        title: "More details",
        payload: "ENTRY INFO"
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
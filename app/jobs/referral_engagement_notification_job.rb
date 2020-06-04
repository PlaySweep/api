class ReferralEngagementNotificationJob < ApplicationJob
    queue_as :low
  
    def perform referrer_id
      referrer = User.find(referrer_id)
      if referrer.active_referrals.completed.size.include?(User::REFERRAL_THRESHOLD)
        referrer_notification_copy = referrer.account.copies.where(category: "Referral Engagement Notification").sample.message
        referrer_notification_copy_interpolated = referrer_notification_copy % { first_name: referrer.first_name, referral_count: referrer.active_referrals.completed.size }
        quick_replies = FacebookParser::QuickReplyObject.new([
          { content_type: :text,
            title: "Play now",
            payload: "PLAY",
            image_url: referrer.current_team.image
          },
          {
            content_type: :text,
            title: "Share",
            payload: "SHARE"
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
  end
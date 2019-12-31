class ReferralEngagementNotificationJob < ApplicationJob
    queue_as :low
  
    def perform referrer_id
      referrer = User.find(referrer_id)
      if referrer.referrals.size == 3
        referrer_notification_copy = referrer.account.copies.where(category: "Referral Engagement Notification").sample.message
        referrer_notification_copy_interpolated = referrer_notification_copy % { first_name: referrer.first_name, referral_count: referrer.referrals.size }
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
class NotifyBadgeJob < ApplicationJob
    queue_as :low
  
    def perform user_id, prize_id
      user = User.find(user_id)
      prize = Prize.find(prize_id)
      user_notification_banner_copy = user.account.copies.where(category: "Notify Badge Banner").sample.message
      user_notification_banner_copy_interpolated = user_notification_banner_copy % { name: user.first_name, level: user.badges.current.achievement.level.ordinalize }
      
      user_notification_copy = user.account.copies.where(category: "Notify Badge Action").sample.message
      user_notification_copy_interpolated = user_notification_copy % { prize: prize.product.name, action: prize.product.is_digital? ? "You now have 1 additional entry into your next local contest, which can increase your chances for winning the contest prize!" : "Tap below to confirm your prize 🎉" }

      url = "#{ENV["WEBVIEW_URL"]}/prize_confirmation/#{prize_id}/#{user.slug}"
      
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
        message: user_notification_banner_copy_interpolated,
        notification_type: "SILENT_PUSH"
      )
  
      if prize.product.is_digital?
        FacebookMessaging::Standard.deliver(
          user: user,
          message: user_notification_copy_interpolated,
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      else
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Confirm your prize!",
          message: user_notification_copy_interpolated,
          url: url,
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      end
    end
  end
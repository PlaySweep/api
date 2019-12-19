class NotifyBadgeJob < ApplicationJob
    queue_as :low
  
    def perform user_id
      user = User.find(user_id)
      user_notification_copy = user.account.copies.where(category: "Notify Badge").sample.message
      user_notification_copy_interpolated = user_notification_copy % { name: user.first_name, badge: user.badges.current.achievement.name }
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
      # TODO Set up a new link
      url = "#{ENV["WEBVIEW_URL"]}/referral_program?slug=#{user.slug}"
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Check out your prize!",
        message: user_notification_copy_interpolated,
        url: url,
        notification_type: "SILENT_PUSH"
      )
    end
  end
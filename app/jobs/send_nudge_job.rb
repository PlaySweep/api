class SendNudgeJob < ApplicationJob
  queue_as :low

  def perform nudger_id, nudged_id
    nudger = User.find_by(id: nudger_id)
    nudged = User.find_by(id: nudged_id)
    if nudged.confirmed
      quick_replies = FacebookParser::QuickReplyObject.new([
        { content_type: :text,
          title: "Play now",
          payload: "PLAY",
          image_url: nudged.current_team.image
        }
      ]).objects
      FacebookMessaging::Standard.deliver(
        user: nudged,
        message: "Hey #{nudged.first_name}, #{nudger.first_name} #{nudger.last_name} is nudging you to play!",
        notification_type: "SILENT_PUSH",
        quick_replies: quick_replies
      )
    else
      FacebookMessaging::Standard.deliver(
        user: nudged,
        message: "Hey #{nudged.first_name}, #{nudger.first_name} #{nudger.last_name} is nudging you to play!",
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: nudged,
        title: "Confirm your account",
        message: "It's only a few more steps, #{nudged.first_name}!",
        url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{nudged.slug}",
        notification_type: "NO_PUSH"
      )
    end
  end
end
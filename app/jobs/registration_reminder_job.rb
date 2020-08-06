class RegistrationReminderJob < ApplicationJob
  queue_as :low

  def perform user_id
    user = User.find_by(id: user_id)
    unless user_id.nil? || user.confirmed
      # Notification Message
      registration_engagement_notification_copy = user.account.copies.active.where(category: "Registration Reminder Notification").sample.message
      next_game = Slate.filtered(user.current_team.id).pending.ascending.first
      if next_game.present?
        seconds = (next_game.start_time.in_time_zone - Time.now.in_time_zone).to_i
        hours = (seconds / 3600)
        time_until_next_game = hours >= 12 ? "soon" : "in #{"%d" % [hours]} hours"
      else
        time_until_next_game = "soon"
      end
      registration_engagement_notification_copy_interpolated = registration_engagement_notification_copy % { first_name: user.first_name, team_abbreviation: user.current_team.abbreviation, time_until_next_game: time_until_next_game }
      
      # Button Message Prompt
      registration_engagement_prompt_copy = user.account.copies.active.where(category: "Registration Reminder Prompt").sample.message
      if next_game.present?
        current_prize = "a #{next_game.prize.product.name}"
      else
        current_prize = "winning cool #{user.account.name} and #{user.account.friendly_name} prizes"
      end
      registration_engagement_prompt_copy_interpolated = registration_engagement_prompt_copy % { current_prize: current_prize }
      url = "#{ENV['WEBVIEW_URL']}/messenger/#{user.facebook_uuid}"
      quick_replies = FacebookParser::QuickReplyObject.new([
        {
          content_type: :text,
          title: "How to play",
          payload: "HOW TO PLAY START"
        },
        {
          content_type: :text,
          title: "Help",
          payload: "HELP"
        }
      ]).objects
      FacebookMessaging::Standard.deliver(
        user: user,
        message: registration_engagement_notification_copy_interpolated,
        notification_type: "REGULAR"
      )

      FacebookMessaging::Button.deliver(
        user: user,
        title: "Start playing now!",
        message: registration_engagement_prompt_copy_interpolated,
        quick_replies: quick_replies,
        notification_type: "NO_PUSH"
      )
    end
  end
end
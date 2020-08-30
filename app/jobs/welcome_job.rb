class WelcomeJob < ApplicationJob
  queue_as :critical

  def perform user_id
    unless user_id.nil?
      user = User.find(user_id)
      welcome_copy = user.account.copies.active.where(category: "Welcome").sample.message
      welcome_interpolated = welcome_copy % { first_name: user.first_name }
      welcome_onboarding_copy = user.account.copies.active.where(category: "Welcome Onboarding").sample.message
      welcome_onboarding_interpolated = welcome_onboarding_copy % { team_abbreviation: user.current_team.abbreviation }
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
      if user.current_team
        if user.current_team.medias.find_by(category: "Welcome")
          FacebookMessaging::ImageAttachment.deliver(user: user, image_url: user.current_team.medias.find_by(category: "Welcome").url)  
        end
  
        FacebookMessaging::Standard.deliver(
          user: user,
          message: welcome_interpolated,
          notification_type: "NO_PUSH"
        )
  
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Start playing now!",
          message: welcome_onboarding_interpolated,
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      end
    end
  end
end
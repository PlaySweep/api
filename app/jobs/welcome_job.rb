class WelcomeJob < ApplicationJob
  queue_as :critical

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    url = "#{ENV['WEBVIEW_URL']}/messenger/#{user.facebook_uuid}"
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Ready to play?",
        payload: "PLAY READY"
      },
      {
        content_type: :text,
        title: "HOW TO PLAY START",
        payload: "HELP"
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
      
      team_onboarding_copy = user.account.copies.where(category: "Welcome Team Onboarding").sample.message
      team_onboarding_interpolated = team_onboarding_copy % { team_abbreviation: user.current_team.abbreviation }
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: "#{welcome_interpolated}\n\n#{team_onboarding_interpolated}",
        quick_replies: quick_replies,
        notification_type: "NO_PUSH"
      )
    end
  end
end
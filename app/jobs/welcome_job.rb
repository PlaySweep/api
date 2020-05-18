class WelcomeJob < ApplicationJob
  queue_as :critical

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    url = "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}"
    if user.current_team
      if user.current_team.medias.find_by(category: "Welcome")
        FacebookMessaging::ImageAttachment.deliver(user: user, image_url: user.current_team.medias.find_by(category: "Welcome").url)  
      end
      
      team_onboarding_copy = user.account.copies.where(category: "Welcome Team Onboarding").sample.message
      team_onboarding_interpolated = team_onboarding_copy % { team_abbreviation: team.abbreviation }
      FacebookMessaging::Standard.deliver(
        user: user,
        message: "#{welcome_interpolated}\n\n#{team_onboarding_interpolated}",
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: "Just tap below to get this party started 👇",
        url: url
      )
    else
      national_onboarding_copy = user.account.copies.where(category: "Welcome National Onboarding").sample.message
      FacebookMessaging::Standard.deliver(
        user: user,
        message: "#{welcome_interpolated}\n\n#{national_onboarding_copy}",
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: "Just tap below to get this party started 👇",
        url: url
      )
    end
  end
end
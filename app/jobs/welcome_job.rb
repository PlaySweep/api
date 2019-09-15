class WelcomeJob < ApplicationJob
  @queue = :welcome_job

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    url = "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}"
    FacebookMessaging::Standard.deliver(
      user: user,
      message: welcome_interpolated,
      notification_type: "SILENT_PUSH"
    )
    if user.roles.find_by(resource_type: "Team")
      team = user.roles.find_by(resource_type: "Team").resource
      FacebookMessaging::ImageAttachment.deliver(user: user, image_url: team.entry_image)
      team_onboarding_copy = user.account.copies.where(category: "Welcome Team Onboarding").sample.message
      team_onboarding_interpolated = team_onboarding_copy % { team_abbreviation: team.abbreviation }
      FacebookMessaging::Standard.deliver(user: user, message: team_onboarding_interpolated)
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: "Just tap below to get this party started 👇",
        url: url
      )
    else
      national_onboarding_copy = user.account.copies.where(category: "Welcome National Onboarding").sample.message
      FacebookMessaging::Standard.deliver(user: user, message: national_onboarding_copy)
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: "Just tap below to get this party started 👇",
        url: url
      )
    end
  end
end
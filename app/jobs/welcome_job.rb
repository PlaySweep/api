class WelcomeJob < ApplicationJob
  queue_as :critical

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    url = "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}"
    team = user.current_team
    team_onboarding_copy = user.account.copies.where(category: "Welcome Team Onboarding").sample.message
    team_onboarding_interpolated = team_onboarding_copy % { team_abbreviation: team.abbreviation }
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Let's go!",
      message: "#{welcome_interpolated}\n\n#{team_onboarding_interpolated}",
      url: url,
      notification_type: "SILENT_PUSH"
    )
  end
end
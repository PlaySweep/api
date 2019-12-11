class WelcomeGenericAdJob < ApplicationJob
  queue_as :critical

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    url = "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}"
    team = user.current_team
    ad_onboarding_copy = user.account.copies.where(category: "Welcome Generic Ad Onboarding").sample.message
    ad_onboarding_interpolated = ad_onboarding_copy % { team_abbreviation: "Patriots" }
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Let's go!",
      message: "#{welcome_interpolated}\n\n#{ad_onboarding_interpolated}",
      url: url,
      notification_type: "SILENT_PUSH"
    )
  end
end
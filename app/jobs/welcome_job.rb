class WelcomeJob < ApplicationJob
  @queue = :welcome_job

  def perform user_id
    user = User.find(user_id)
    welcome_copy = user.account.copies.where(category: "Welcome").sample.message
    welcome_interpolated = welcome_copy % { first_name: user.first_name }
    FacebookMessaging::Standard.deliver(user, welcome_interpolated, "SILENT_PUSH")
    if user.roles.find_by(resource_type: "Team")
      team = user.roles.find_by(resource_type: "Team").resource
      FacebookMessaging::ImageAttachment.deliver(user, team.entry_image)
      team_onboarding_copy = user.account.copies.where(category: "Welcome Team Onboarding").sample.message
      team_onboarding_interpolated = team_onboarding_copy % { team_abbreviation: team.abbreviation }
      FacebookMessaging::Standard.deliver(user, team_onboarding_interpolated)
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}")
    else
      national_onboarding_copy = user.account.copies.where(category: "Welcome National Onboarding").sample.message
      national_onboarding_interpolated = national_onboarding_copy % { first_name: user.first_name }
      FacebookMessaging::Standard.deliver(user, national_onboarding_interpolated)
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}")
    end
  end
end
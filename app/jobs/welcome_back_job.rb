class WelcomeBackJob < ApplicationJob
  @queue = :welcome_back_job

  def perform user_id
    user = User.find(user_id)
    welcome_back_copy = user.account.copies.where(category: "Welcome Back").sample.message
    welcome_back_interpolated = welcome_back_copy % { first_name: user.first_name }
    if user.confirmed
      team = user.roles.find_by(resource_type: "Team").try(:resource)
      if team
        FacebookMessaging::Standard.deliver(user, "#{welcome_back_interpolated}\n\nYou're currently playing for the #{team.abbreviation} - but you can change by typing 'switch' 👌", "NO_PUSH")
        FacebookMessaging::TextButton.deliver(user, "Play now", "There are more #{team.abbreviation} games to play!", "NO_PUSH")
      else
        FacebookMessaging::Standard.deliver(user, "#{welcome_back_interpolated}\n\nYou still haven't selected a team to play with yet 👐", "NO_PUSH")
        FacebookMessaging::TextButton.deliver(user, "Select a team", "Tap below to see a full list of available teams to choose from 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/teams/initial_load")
      end
    else
      FacebookMessaging::Standard.deliver(user, "#{welcome_back_interpolated}\n\nI notice you still haven't confirmed your account with us.", "NO_PUSH")
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}")
    end
  end
end
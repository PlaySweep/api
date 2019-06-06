class WelcomeBackJob < BudweiserJob
  @queue = :welcome_back_job

  def perform user_id
    user = User.find(user_id)
    if user.confirmed
      if team = user.roles.find_by(resource_type: "Team").try(:resource)
        FacebookMessaging::Standard.deliver(user, "Welcome back to the Budweiser Sweep #{user.first_name}!\n\nYou're currently playing for the #{team.abbreviation} - but you can change by typing 'switch' 👌", "NO_PUSH")
        FacebookMessaging::TextButton.deliver(user, "Play now", "There are more #{team.abbreviation} games to play!", "NO_PUSH")
      else
        FacebookMessaging::Standard.deliver(user, "Welcome back to the Budweiser Sweep #{user.first_name}!\n\nYou still haven't selected a team to play with yet 👐", "NO_PUSH")
        FacebookMessaging::TextButton.deliver(user, "Select a team", "Tap below to see a full list of available teams to choose from 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/teams/initial_load")
      end
    else
      FacebookMessaging::Standard.deliver(user, "Welcome back to the Budweiser Sweep #{user.first_name}!\n\nI notice you still haven't confirmed your account with us 👐", "NO_PUSH")
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/account")
    end
  end
end
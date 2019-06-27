class WelcomeJob < BudweiserJob
  @queue = :welcome_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Welcome to the Bud Light Sweep #{user.first_name}!\n\nPlease note that you need to be of legal drinking age to enter.", "SILENT_PUSH")
    if user.roles.find_by(resource_type: "Team")
      team = user.roles.find_by(resource_type: "Team").resource
      FacebookMessaging::ImageAttachment.deliver(user, team.entry_image)
      FacebookMessaging::Standard.deliver(user, "This is a game to test your ability to answer questions correctly about what’s going to happen for every #{team.abbreviation} game this season.\n\nYou’ll definitely want to answer these, as we’re giving away some cool #{team.abbreviation} prizes all season long!")
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/account/initial_load")
    else
      FacebookMessaging::Standard.deliver(user, "The Bud Light Sweep game is your chance to predict the future this football season - answer six questions about football games for your chance to win exclusive prizes!")
      FacebookMessaging::TextButton.deliver(user, "Confirm account", "Just tap below to finish up a few quick details and get started winning prizes 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/account/initial_load")
    end
  end
end



# class WelcomeJob < BudweiserJob
#   @queue = :welcome_job

#   def perform user_id
#     user = User.find(user_id)
#     text = "Welcome to the Bud Light Sweep #{user.first_name}!\n\nIt's good to see you again!\n\nYou know the drill - you must (still) be of legal drinking age to enter.\n\nThe Bud Light Sweep game is your chance to predict the future this football season - answer six questions about football games for your chance to win exclusive prizes!\n\nJust tap below to opt-in 👇"
#     if user.roles.find_by(resource_type: "Team")
#       team = user.roles.find_by(resource_type: "Team").resource
#       FacebookMessaging::ImageAttachment.deliver(user, team.entry_image)
#       FacebookMessaging::Standard.deliver(user, "This is a game to test your ability to answer questions correctly about what’s going to happen for every #{team.abbreviation} game this season.\n\nYou’ll definitely want to answer these, as we’re giving away some cool #{team.abbreviation} prizes all season long!")
#       FacebookMessaging::TextButton.deliver(user, "Opt-in Now", "Just tap below to opt-in 👇", "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/account/initial_load")
#     else
#       text = "Welcome to the Bud Light Sweep #{user.first_name}!\n\nIt's good to see you again! You know the drill - you must (still) be of legal drinking age to enter.\n\nThe Bud Light Sweep game is your chance to predict the future this football season - answer six questions about football games for your chance to win exclusive prizes!\n\nGood news, we have your information already! We just need you to opt-in to our Football Sweep rules and you'll be all set to play 👇"
#       FacebookMessaging::TextButton.deliver(user, "Opt-in Now", text, "NO_PUSH", "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/account/initial_load")
#     end
#   end
# end
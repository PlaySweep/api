class WelcomeJob < BudweiserJob
  @queue = :welcome_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Welcome to the Budweiser Sweep #{user.first_name}!\n\nPlease note that you need to be of legal drinking age to enter.", "SILENT_PUSH")
    if user.roles.find_by(resource_type: "Team")
      team = user.roles.find_by(resource_type: "Team").resource
      FacebookMessaging::Standard.deliver(user, "This is a game to test your ability to answer questions correctly about what’s going to happen for every #{team.abbreviation} game this season.\n\nYou’ll definitely want to answer these, as we’re giving away some cool #{team.abbreviation} prizes all season long.")
      FacebookMessaging::Standard.deliver(user, "First, we need to confirm a few details so you can collect your prizes when you win!")
      FacebookMessaging::MediaAttachment.deliver_with_button(user, team.medias.find_by(category: "Onboarding").attachment_id)
    else
      attachment_id = League.find(4).medias.find_by(category: "Onboarding").attachment_id
      FacebookMessaging::Standard.deliver(user, "The Budweiser Sweep game is your chance to predict the future this baseball season - answer three questions about baseball games for your chance to win exclusive prizes.")
      FacebookMessaging::Standard.deliver(user, "First, we need to confirm a few details so you can collect your prizes when you win!")
      FacebookMessaging::MediaAttachment.deliver_with_button(user, attachment_id)
    end
  end
end
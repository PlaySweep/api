class SendLosingSlateMessageJob < BudweiserJob
  @queue = :send_losing_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)

    message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score}! View your results inside ⚾️" : "The #{slate.team.abbreviation} lost #{slate.score}. View your results inside ⚾️"

    messages = [
      { 
        banner: "Even the best hitters don’t bat 1000",
        open: "You didn’t get all 3 right, but play again for another shot! Click below 👇"
      },
      { 
        banner: "Well that one was a swing and a miss #{user.first_name}",
        open: "It's time for you to step back up to the plate, click below to try again 👇"
      },
      { 
        banner: "You got robbed at the warning track and barely missed getting all three right",
        open: "Click below for your shot at more prizes 👇"
      },
      { 
        banner: "The outcome didn't go your way, but don't let that stop you from trying again!",
        open: "More contests available. Click below 👇"
      },
      { 
        banner: "It just wasn't your time...yet",
        open: "You didn't get all 3 right. But we have more prizes and games available now. Click below 👇"
      }
    ]

    sample = messages.sample
    FacebookMessaging::Standard.deliver(user, message, "REGULAR")
    FacebookMessaging::Standard.deliver(user, sample[:banner], "NO_PUSH")
    FacebookMessaging::TextButton.deliver(user, "More Contests", sample[:open], "NO_PUSH")
  end
end
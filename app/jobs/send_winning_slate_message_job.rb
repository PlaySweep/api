class SendWinningSlateMessageJob < BudweiserJob
  @queue = :send_winning_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if slate.global?
      message = "Bud Light Game of the Day (#{slate.score}). View your results inside"
      FacebookMessaging::Standard.deliver(user, message, "REGULAR")
      context_message = user.tied? ? "Congrats #{user.first_name}, you got all 3 right and completed a Bud Light Sweep!\n\nYou're currently tied for #{user.rank.ordinalize} place in the Road to All-Star with #{user.current_sweep_streak} #{user.current_sweep_streak == 1 ? "Sweep" : "Sweeps"} in a row!" : "You're sitting in #{user.rank.ordinalize} place in the Road to All-Star with #{user.current_sweep_streak} #{user.current_sweep_streak == 1 ? "Sweep" : "Sweeps"} in a row!"
      FacebookMessaging::Standard.deliver(user, "#{context_message}", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score}! View your results inside" : "The #{slate.team.abbreviation} lost #{slate.score}. View your results inside"
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      context_message = "Nice job on hitting a Bud Light Sweep #{user.first_name}!\n\nYou've been entered into tomorrow's drawing for #{slate.prizes.first.product.name}!"
      FacebookMessaging::Standard.deliver(user, "#{context_message}", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_bud(user)
    end
  end
end
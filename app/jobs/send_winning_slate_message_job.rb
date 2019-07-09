class SendWinningSlateMessageJob < BudweiserJob
  @queue = :send_winning_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if slate.global?
      message = "Home Run Derby results inside ⚾️"
      FacebookMessaging::Standard.deliver(user, message, "REGULAR")
      context_message = "#{user.first_name}, you got all 3 right and completed a Budweiser Sweep!\n\nYou've been entered into our drawing and will be notified in the next 24 hours if you have been selected as our prize winner!"
      FacebookMessaging::Standard.deliver(user, "#{context_message}", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score}! View your results inside ⚾️" : "The #{slate.team.abbreviation} lost #{slate.score}. View your results inside ⚾️"
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      context_message = "#{user.first_name}, you got all 3 right and completed a Budweiser Sweep!\n\nYou've been entered into our drawing and will be notified in the next 24 hours if you have been selected as our #{slate.prizes.first.product.name} winner!"
      FacebookMessaging::Standard.deliver(user, "#{context_message}", "NO_PUSH")
      FacebookMessaging::Carousel.deliver_global(user)
    end
  end
end
class SendWinningSlateMessageJob < ApplicationJob
  @queue = :send_winning_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    if slate.global?
      message = "#{slate.name} results inside"
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      national_winning_slate_copy = user.account.copies.where(category: "National Winning Slate").sample.message
      interpolated_national_winning_slate_copy = national_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name }
      FacebookMessaging::Standard.deliver(user, interpolated_national_winning_slate_copy, "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : slate.result == "L" ? "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} tied #{slate.score} - view your results inside" 
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      local_winning_slate_copy = user.account.copies.where(category: "Local Winning Slate").sample.message
      interpolated_local_winning_slate_copy = local_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name }
      FacebookMessaging::Standard.deliver(user, interpolated_local_winning_slate_copy, "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    end
  end
end
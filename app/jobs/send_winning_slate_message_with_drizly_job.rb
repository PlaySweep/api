class SendWinningSlateMessageWithDrizlyJob < ApplicationJob
  @queue = :send_winning_slate_message_job_with_drizly_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    promotion = user.promotions.find_by(type: "DrizlyPromotion", category: "Sweep", slate_id: slate.id)
    if slate.global?
      message = "#{slate.name} results inside"
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      drizly_national_winning_slate_copy = user.account.copies.where(category: "Drizly National Winning Slate").sample.message
      interpolated_drizly_national_winning_slate_copy = drizly_national_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name, drizly_value: promotion.price_in_format }
      FacebookMessaging::Standard.deliver(user, interpolated_drizly_national_winning_slate_copy, "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside"
      FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
      drizly_local_winning_slate_copy = user.account.copies.where(category: "Drizly Local Winning Slate").sample.message
      interpolated_drizly_local_winning_slate_copy = drizly_local_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name, drizly_value: promotion.price_in_format }
      FacebookMessaging::Standard.deliver(user, interpolated_drizly_local_winning_slate_copy, "NO_PUSH")
      FacebookMessaging::Carousel.deliver_team(user)
    end
  end
end
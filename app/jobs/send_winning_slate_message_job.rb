class SendWinningSlateMessageJob < ApplicationJob
  queue_as :low

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      },
      { 
        content_type: :text,
        title: "Play again",
        payload: "PLAY",
        image_url: user.current_team.image
      },
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    if slate.global?
      result_message = "#{slate.name} results inside: #{slate.score}"
      FacebookMessaging::Standard.deliver(
        user: user,
        message: result_message,
        notification_type: "REGULAR"
      )
      national_winning_slate_copy = user.account.copies.where(category: "National Winning Slate").sample.message
      interpolated_national_winning_slate_copy = national_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name }
      FacebookMessaging::Standard.deliver(
        user: user,
        message: interpolated_national_winning_slate_copy,
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    else
      result_message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : slate.result == "L" ? "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} tied #{slate.score} - view your results inside" 
      FacebookMessaging::Standard.deliver(
        user: user,
        message: result_message,
        notification_type: "REGULAR"
      )
      local_winning_slate_copy = user.account.copies.where(category: "Local Winning Slate").sample.message
      interpolated_local_winning_slate_copy = local_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name }
      FacebookMessaging::Standard.deliver(
        user: user,
        message: interpolated_local_winning_slate_copy,
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    end
  end
end
class SendWinningSlateMessageWithDrizlyJob < ApplicationJob
  @queue = :send_winning_slate_message_job_with_drizly_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    promotion = user.promotions.find_by(type: "DrizlyPromotion", category: "Sweep", slate_id: slate.id)
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      },
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    if slate.global?
      result_message = "#{slate.name} results inside"
      FacebookMessaging::Standard.deliver(
        user: user,
        message: result_message,
        notification_type: "REGULAR"
      )
      drizly_national_winning_slate_copy = user.account.copies.where(category: "Drizly National Winning Slate").sample.message
      interpolated_drizly_national_winning_slate_copy = drizly_national_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name, drizly_value: promotion.value_in_format }
      image = user.account.medias.find_by(category: "Drizly Lockup")
      FacebookMessaging::MediaAttachment.deliver(user: user, attachment_id: image.attachment_id)
      FacebookMessaging::Standard.deliver(
        user: user,
        message: interpolated_drizly_national_winning_slate_copy,
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::GlobalContest.deliver(user: user, quick_replies: quick_replies)
    else
      result_message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : slate.result == "L" ? "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} tied #{slate.score} - view your results inside"
      FacebookMessaging::Standard.deliver(
        user: user,
        message: result_message,
        notification_type: "REGULAR"
      )
      drizly_local_winning_slate_copy = user.account.copies.where(category: "Drizly Local Winning Slate").sample.message
      interpolated_drizly_local_winning_slate_copy = drizly_local_winning_slate_copy % { first_name: user.first_name, event_size: slate.events.size, prize_name: slate.prizes.first.product.name, drizly_value: promotion.value_in_format }
      image = user.account.medias.find_by(category: "Drizly Lockup")
      FacebookMessaging::MediaAttachment.deliver(
        user: user,
        attachment_id: image.attachment_id
      )
      FacebookMessaging::Standard.deliver(
        user: user,
        message: interpolated_drizly_local_winning_slate_copy,
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    end
  end
end
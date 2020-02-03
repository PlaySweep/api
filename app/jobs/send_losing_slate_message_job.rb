class SendLosingSlateMessageJob < ApplicationJob
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
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    if slate.contest_id?
      # number_of_correct_answers = user.picks.where(user_id: user.id, event_id: slate.events.map(&:id)).win.size
      # rank = user.account.active_leaderboard ? "#{user.account.active_leaderboard.rank_for(user.id).to_i}#{user.account.active_leaderboard.rank_for(user.id).to_i.ordinalize.last(2)}" : 0
      # points = number_of_correct_answers == 1 ? "point" : "points"
      # message = "#{slate.name} results inside: #{slate.score}"
      # national_losing_slate_copy = user.account.copies.where(category: "Contest Losing Slate").sample.message
      # national_interpolated_losing_slate_copy = national_losing_slate_copy % { first_name: user.first_name, number_of_correct_answers: number_of_correct_answers, points: points, contest_score: number_of_correct_answers + 1, rank: rank, contest_description: slate.contest.description }

      # FacebookMessaging::Standard.deliver(
      #   user: user, 
      #   message: message, 
      #   notification_type: "SILENT_PUSH"
      # )
      # FacebookMessaging::Standard.deliver(
      #   user: user, 
      #   message: national_interpolated_losing_slate_copy, 
      #   notification_type: "NO_PUSH"
      # )
      # FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
      message = "#{slate.name} results inside: #{slate.score}"
      FacebookMessaging::Standard.deliver(
        user: user,
        message: message,
        notification_type: "SILENT_PUSH"
      )

      losing_slate_copy = user.account.copies.where(category: "Losing Slate").sample.message
      interpolated_losing_slate_copy = losing_slate_copy % { first_name: user.first_name }
      FacebookMessaging::Standard.deliver(
        user: user, 
        message: interpolated_losing_slate_copy, 
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : slate.result == "L" ? "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} tied #{slate.score} - view your results inside"
      losing_slate_copy = user.account.copies.where(category: "Losing Slate").sample.message
      interpolated_losing_slate_copy = losing_slate_copy % { first_name: user.first_name }

      FacebookMessaging::Standard.deliver(
        user: user, 
        message: message, 
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Standard.deliver(
        user: user, 
        message: interpolated_losing_slate_copy, 
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    end
  end
end
class SendLosingSlateMessageJob < ApplicationJob
  @queue = :send_losing_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)

    if slate.global?
      message = "#{slate.name} results inside"
    else
      message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score} - view your results inside" : slate.result == "L" ? "The #{slate.team.abbreviation} lost #{slate.score} - view your results inside" : "The #{slate.team.abbreviation} tied #{slate.score} - view your results inside"
    end

    losing_slate_copy = user.account.copies.where(category: "Losing Slate").sample.message
    interpolated_losing_slate_copy = losing_slate_copy % { first_name: user.first_name }

    FacebookMessaging::Standard.deliver(user: user, message: message, notification_type: "REGULAR")
    FacebookMessaging::Button.deliver(
      user: user,
      title: "More Contests",
      message: interpolated_losing_slate_copy,
      notification_type: "NO_PUSH"
    )
  end
end
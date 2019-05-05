class SendWinningSlateMessageJob < BudweiserJob
  @queue = :send_winning_slate_message_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    message = slate.result == "W" ? "The #{slate.team.abbreviation} won #{slate.score}! View your results inside ⚾️" : "The #{slate.team.abbreviation} lost #{slate.score}. View your results inside ⚾️"
    FacebookMessaging::Standard.deliver(user, "#{message}", "REGULAR")
    winning_message = "#{user.first_name}, you got all 3 right and completed a Budweiser Sweep!"
    drawing_message = "You've been entered into our drawing and will be notified in the next 24 hours if you have been selected as our #{slate.prizes.first.product.name} winner!"
    FacebookMessaging::TextButton.deliver(user, "Available Contests", "#{winning_message}\n\n#{drawing_message}", "NO_PUSH")
  end
end
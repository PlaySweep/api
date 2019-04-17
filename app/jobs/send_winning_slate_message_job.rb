class SendWinningSlateMessageJob < BudweiserJob
  @queue = :send_winning_slate_message_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "#{user.first_name}, you completed a Budweiser Sweep and got all 3 right!", "REGULAR")
    FacebookMessaging::Standard.deliver(user, "That means that you’ll be entered into a drawing that will happen in the next 24-48 hours to win an exclusive prize.\n\nIf you win the drawing, you’ll receive a message right here.", "NO_PUSH")
    FacebookMessaging::TextButton.deliver(user, "See Available Contests", "Oh, and don’t forget to answer the next Sweep questions for another chance to win by tapping below 👇", "NO_PUSH")
  end
end
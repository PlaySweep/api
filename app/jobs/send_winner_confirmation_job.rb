class SendWinnerConfirmationJob < BudweiserJob
  @queue = :send_winner_confirmation_job

  def perform user_id
    user = User.find(user_id)
    FacebookMessaging::Standard.deliver(user, "Congratulations #{user.first_name}, you were selected as our lottery winner! ", "REGULAR")
    FacebookMessaging::TextButton.deliver(user, "Confirm Prize", "To help us deliver the goods, please confirm your prize and details for us below 👇", "NO_PUSH")
  end
end
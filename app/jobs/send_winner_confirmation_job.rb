class SendWinnerConfirmationJob < BudweiserJob
  @queue = :send_winner_confirmation_job

  def perform slate_id, user_id
    slate = Slate.find_by(id: slate_id)
    user = User.find_by(id: user_id)
    FacebookMessaging::Standard.deliver(user, "Congratulations #{user.first_name}, you were selected as our lottery winner! ", "REGULAR")
    url = "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/slates/#{slate_id}/confirm_prizing"
    FacebookMessaging::TextButton.deliver(user, "Confirm Your Prize", "To help us deliver the goods, please confirm your prize and details for us below 👇", url, "NO_PUSH")
  end
end
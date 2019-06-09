class SendWinnerConfirmationJob < BudweiserJob
  @queue = :send_winner_confirmation_job

  def perform slate_id, user_id
    slate = Slate.find_by(id: slate_id)
    user = User.find_by(id: user_id)
    FacebookMessaging::Standard.deliver(user, "Congratulations #{user.first_name}, you were selected as our drawing winner 🎉! ", "REGULAR")
    url = "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/slates/#{slate_id}/1/confirm_prize"
    FacebookMessaging::TextButton.deliver(user, "Confirm Now", "Confirm in the next 48 hours to receive your prize 👇", "NO_PUSH", url)
  end
end
class SendWinnerConfirmationJob < ApplicationJob
  @queue = :send_winner_confirmation_job

  def perform slate_id, user_id
    slate = Slate.find_by(id: slate_id)
    user = User.find_by(id: user_id)
    winner_confirmation_banner_copy = user.account.copies.where(category: "Winner Confirmation Banner").sample.message
    interpolated_winner_confirmation_banner_copy = winner_confirmation_banner_copy % { first_name: user.first_name }

    winner_confirmation_action_copy = user.account.copies.where(category: "Winner Confirmation Action").sample.message
    
    FacebookMessaging::Standard.deliver(user, interpolated_winner_confirmation_copy, "REGULAR")
    url = "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/slates/#{slate_id}/1/confirm_prize"
    FacebookMessaging::TextButton.deliver(user, "Confirm Now", winner_confirmation_action_copy, "NO_PUSH", url)
  end
end
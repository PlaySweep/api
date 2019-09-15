class SendWinnerConfirmationJob < ApplicationJob
  @queue = :send_winner_confirmation_job

  def perform slate_id, user_id
    slate = Slate.find_by(id: slate_id)
    user = User.find_by(id: user_id)
    winner_confirmation_banner_copy = user.account.copies.where(category: "Winner Confirmation Banner").sample.message
    interpolated_winner_confirmation_banner_copy = winner_confirmation_banner_copy % { first_name: user.first_name }

    winner_confirmation_action_copy = user.account.copies.where(category: "Winner Confirmation Action").sample.message
    
    FacebookMessaging::Standard.deliver(
      user: user,
      message: interpolated_winner_confirmation_banner_copy,
      notification_type: "REGULAR"
    )
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Confirm Now",
      message: winner_confirmation_action_copy,
      url: "#{ENV["WEBVIEW_URL"]}/confirm_prize/#{user.slug}/#{slate_id}",
      notification_type: "NO_PUSH"
    )
  end
end
class SendWinnerConfirmationJob < ApplicationJob
  queue_as :high

  def perform user_id, prize_id
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
      url: "#{ENV["WEBVIEW_URL"]}/prize_confirmation/#{prize_id}/#{user.slug}",
      notification_type: "NO_PUSH"
    )
  end
end
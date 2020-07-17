class SendWinnerConfirmationJob < ApplicationJob
  queue_as :high

  def perform user_id, prize_id, card_id
    user = User.find_by(id: user_id)
    card = Card.find_by(id: card_id)
    if card.loss?
      confirmation_banner_copy = user.account.copies.where(category: "Loser Confirmation Banner").sample.message    
    else
      confirmation_banner_copy = user.account.copies.where(category: "Winner Confirmation Banner").sample.message
    end
    interpolated_confirmation_banner_copy = confirmation_banner_copy % { first_name: user.first_name }
    confirmation_action_copy = user.account.copies.where(category: "Winner Confirmation Action").sample.message
    interpolated_confirmation_action_copy = confirmation_action_copy % { time_zone: user.current_team.time_zone.split('(')[0].strip }

    FacebookMessaging::Standard.deliver(
      user: user,
      message: interpolated_confirmation_banner_copy,
      notification_type: "REGULAR"
    )
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Confirm Now",
      message: interpolated_confirmation_action_copy,
      url: "#{ENV["WEBVIEW_URL"]}/prize_confirmation/#{prize_id}/#{user.slug}",
      notification_type: "NO_PUSH"
    )
  end
end
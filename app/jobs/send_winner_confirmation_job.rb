class SendWinnerConfirmationJob < ApplicationJob
  queue_as :high

  def perform user_id, prize_id, card_id
    user = User.find_by(id: user_id)
    card = Card.find_by(id: card_id)
    if card.loss?
      confirmation_banner_copy = user.account.copies.active.where(category: "Loser Confirmation Banner").sample.message    
    else
      confirmation_banner_copy = user.account.copies.active.where(category: "Winner Confirmation Banner").sample.message
    end
    interpolated_confirmation_banner_copy = confirmation_banner_copy % { first_name: user.first_name }
    confirmation_action_copy = user.account.copies.active.where(category: "Winner Confirmation Action").sample.message

    FacebookMessaging::Standard.deliver(
      user: user,
      message: interpolated_confirmation_banner_copy,
      notification_type: "REGULAR"
    )
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Confirm Now",
      message: confirmation_action_copy,
      url: "#{ENV["WEBVIEW_URL"]}/messenger/#{user.facebook_uuid}/#{prize_id}-prize",
      notification_type: "NO_PUSH"
    )
  end
end
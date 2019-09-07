class SendSlateNotificationWithDrizlyJob < ApplicationJob
  @queue = :send_slate_notification_with_drizly_job

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    promotion = user.promotions.find_by(type: "DrizlyPromotion", category: "Playing", slate_id: slate.id)
    initial_drizly_pick_confirmation_copy = user.account.copies.where(category: "Drizly Initial Pick Confirmation").sample.message
    initial_drizly_pick_confirmation_interpolated = initial_drizly_pick_confirmation_copy % { first_name: user.first_name, drizly_value: promotion.price_in_format }
    FacebookMessaging::Standard.deliver(user, initial_drizly_pick_confirmation_interpolated, "NO_PUSH")
    FacebookMessaging::Carousel.deliver_team(user)
    
  end
end
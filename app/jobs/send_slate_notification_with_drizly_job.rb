class SendSlateNotificationWithDrizlyJob < ApplicationJob
  queue_as :high

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    promotion = user.promotions.find_by(type: "DrizlyPromotion", category: "Playing", slate_id: slate.id)
    # TODO Handle a new way to message
  end
end
class NotifyBadgeJob < ApplicationJob
    queue_as :low
  
    def perform user_id, prize_id
      user = User.find(user_id)
      prize = Prize.find(prize_id)
      # TODO Handle a new way to message for hitting a badge
    end
  end
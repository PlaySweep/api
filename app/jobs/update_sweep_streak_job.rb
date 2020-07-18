class UpdateSweepStreakJob < ApplicationJob
  queue_as :low

  def perform card_id
    card = Card.find_by(id: card_id)
    streak = card.user.streaks.find_or_create_by(type: "SweepStreak")
    streak.update_attributes(current: streak.current += 1)
    streak.update_attributes(highest: streak.current) if streak.highest < streak.current
  end
end
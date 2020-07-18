class ResetStreakJob < ApplicationJob
  queue_as :low

  def perform pick_id
    pick = Pick.find_by(id: pick_id)
    streak = pick.user.streaks.find_or_create_by(type: "PickStreak")
    streak.update_attributes(current: 0)
  end
end
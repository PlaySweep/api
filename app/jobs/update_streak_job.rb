class UpdateStreakJob < ApplicationJob
  queue_as :low

  def perform pick_id
    pick = Pick.find_by(id: pick_id)
    streak = pick.user.streaks.find_or_create_by(type: "PickStreak")
    OwnerService.new(user: pick.user, slate: pick.event.slate).run(type: :pick)
    ContestService.new(user: pick.user, contest: pick.event.slate.contest).run(type: :pick)
    streak.update_attributes(current: streak.current += 1)
    streak.update_attributes(highest: streak.current) if streak.highest < streak.current
  end
end
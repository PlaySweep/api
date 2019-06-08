class SweepStreak < Streak

  after_update :streak_hit?

  private

  def streak_hit?
    Popcorn.notify("4805227771", "(#{user.id}). #{user.full_name} just won the Road to All-Star.") if saved_change_to_highest?(to: 6)
  end
end
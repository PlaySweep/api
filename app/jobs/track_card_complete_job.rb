class TrackCardCompleteJob < BudweiserJob
  @queue = :track_card_complete_job

  def perform pick_id
    pick = Pick.find(pick_id)
    Analytics::Budweiser::User.new(pick.user).card_completed(pick.current_slate.try(:prizing_category))
  end
end
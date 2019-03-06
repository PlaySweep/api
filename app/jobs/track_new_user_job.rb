class TrackCardStartedJob < BudweiserJob
  @queue = :track_card_started_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    Analytics::Budweiser::User.new(user).new_user
  end
end
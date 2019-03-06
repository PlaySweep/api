class TrackAccountConfirmedJob < BudweiserJob
  @queue = :track_account_confirmed_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    Analytics::Budweiser::User.new(user).account_confirmed
  end
end
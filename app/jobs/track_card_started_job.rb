class TrackCardStartedJob < BudweiserJob
  @queue = :track_card_started_job

  def perform card_id
    card = Card.find(card_id)
    Analytics::Budweiser::User.new(card.user).card_started(card.slate.try(:prizing_category))
  end
end
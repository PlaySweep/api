class ResultCardsJob < BudweiserJob
  @queue = :result_cards_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    slate.cards.each { |card| card.user.won_slate?(slate) ? card.win! : card.loss! }
  end
end
class ResultCardsJob < ApplicationJob
  queue_as :high

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    slate.cards.each { |card| card.user.won_slate?(slate) ? card.win! : card.loss! }
  end
end
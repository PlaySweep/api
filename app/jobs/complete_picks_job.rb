class CompletePicksJob < ApplicationJob
  queue_as :low

  def perform event_id
    event = Event.find(event_id)
    event.picks.where(selection_id: event.winner_ids).map(&:win!)
    event.picks.where(selection_id: event.loser_ids).map(&:loss!)
    event.update_columns(status: Event::CLOSED)
    event.slate.ready! if event.last?
  end
end
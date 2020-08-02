class CompletePicksJob < ApplicationJob
  queue_as :low

  def perform event_id
    event = Event.find(event_id)
    slate = Slate.find(event.slate_id)
    event.picks.where(selection_id: event.winner_ids).map(&:win!)
    event.picks.where(selection_id: event.loser_ids).map(&:loss!)
    event.update_columns(status: Event::CLOSED)
    slate.ready! if slate.events.closed.size == slate.events.size
  end
end
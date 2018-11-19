class Pick < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :selection

  after_create :complete_slate?

  private

  def complete_slate?
    current_slate = Slate.find(event.slate_id)
    if current_slate.pending?
      user.cards.create(slate_id: current_slate.id) if current_slate.events.size == user.events.for_slate(current_slate.id).size
    end
  end
end
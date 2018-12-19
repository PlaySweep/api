class Pick < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  after_create :is_slate_ready?

  def current_slate
    event.slate
  end

  private

  def is_slate_ready?
    if current_slate.pending?
      user.cards.create(slate_id: current_slate.id) if current_slate.events.incomplete.size == user.events.incomplete.for_slate(current_slate.id).size
    end
  end
end
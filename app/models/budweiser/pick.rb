class Pick < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  validates :selection_id, uniqueness: { scope: :event_id, message: "only 1 per event" }

  scope :for_slate, ->(slate_id) { joins(:event).where('events.slate_id = ?', slate_id) }

  def current_slate
    event.slate
  end

end
class Pick < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  validates :selection_id, :event_id, uniqueness: { scope: :user_id, message: "only 1 per event" }

  around_save :catch_uniqueness_exception

  scope :for_slate, ->(slate_id) { joins(:event).where('events.slate_id = ?', slate_id) }
  scope :duplicates, -> { select([:user_id, :selection_id, :event_id]).group(:user_id, :selection_id, :event_id).having("count(*) > 1").size }
  scope :descending, -> { joins(:event).merge(Event.descending) }

  def current_slate
    event.slate
  end

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:selection, :taken)
  end

end
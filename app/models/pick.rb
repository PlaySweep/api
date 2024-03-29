class Pick < ApplicationRecord
  include ActiveModel::Dirty

  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  validates :selection_id, :event_id, uniqueness: { scope: :user_id, message: "only 1 per event" }

  before_save :is_locked?
  around_save :catch_uniqueness_exception
  after_update :update_streaks, :reset_streaks

  scope :for_slate, ->(slate_id) { joins(:event).where('events.slate_id = ?', slate_id) }
  scope :duplicates, -> { select([:user_id, :selection_id, :event_id]).group(:user_id, :selection_id, :event_id).having("count(*) > 1").size }
  scope :descending, -> { joins(:event).merge(Event.descending) }
  scope :completed, -> { where(status: [1, 2]) }
  scope :unfiltered, -> { joins(:event).merge(Event.unfiltered) }
  scope :most_recent, -> { joins(:event).merge(Event.most_recent) }

  def current_slate
    event.slate
  end

  private

  def is_locked?
    restore_attributes if event.slate.started? and selection_id_changed?
  end

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:selection, :taken)
  end

  def update_streaks
    UpdateStreakJob.perform_later(id) if saved_change_to_status?(from: 'pending', to: 'win')
  end

  def reset_streaks
    ResetStreakJob.perform_later(id) if saved_change_to_status?(from: 'pending', to: 'loss')
  end

end
class Pick < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  validate :has_started?
  validates :selection_id, :event_id, uniqueness: { scope: :user_id, message: "only 1 per event" }

  around_save :catch_uniqueness_exception
  after_update :update_user_streaks

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

  def has_started?
    if event.slate.started?
      self.errors.add(:pick, "Slate has already started")
    end
  end

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:selection, :taken)
  end

  def update_user_streaks
    if saved_change_to_status?(from: 'pending', to: 'win')
      streak = user.streaks.find_or_create_by(type: "PickStreak")
      streak.update_attributes(current: streak.current += 1)
      if streak.highest < streak.current
        streak.update_attributes(highest: streak.current)
      end
    elsif saved_change_to_status?(from: 'pending', to: 'loss')
      user.streaks.find_or_create_by(type: "PickStreak").update_attributes(current: 0)
    end
  end

end
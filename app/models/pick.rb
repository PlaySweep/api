class Pick < ApplicationRecord
  include ActiveModel::Dirty

  PENDING, WIN, LOSS = 0, 1, 2

  belongs_to :event
  belongs_to :user
  belongs_to :selection

  enum status: [ :pending, :win, :loss ]

  validates :selection_id, :event_id, uniqueness: { scope: :user_id, message: "only 1 per event" }

  before_save :has_started?
  around_save :catch_uniqueness_exception
  after_update :update_user_streaks
  after_create :create_card_when_finished

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
    restore_attributes if event.slate.started? and selection_id_changed?
  end

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:selection, :taken)
  end

  def create_card_when_finished
    Card.create(user_id: user_id, slate_id: event.slate_id) if user.completed_selections_for(event.slate)
  end

  def update_user_streaks
    if saved_change_to_status?(from: 'pending', to: 'win')
      OwnerService.new(user, slate: event.slate).run(type: :pick)
      ContestService.new(user, slate: event.slate).run(type: :pick)
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
class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :cardable, polymorphic: true
  has_many :prizes, as: :prizeable, dependent: :destroy

  enum status: [ :pending, :win, :loss ]

  validates :cardable_id, uniqueness: { scope: [:user_id, :cardable_type], message: "only 1 Card per Entry" }

  scope :for_quizzes, -> { where(cardable_type: "Quiz").joins('INNER JOIN quizzes ON quizzes.id = cards.cardable_id') }
  scope :for_slates, -> { where(cardable_type: "Slate").joins('INNER JOIN slates ON slates.id = cards.cardable_id') }
  scope :between_days, ->(resource, from, to) { where("#{resource}.start_time BETWEEN ? AND ?", DateTime.current.beginning_of_day - from.days, DateTime.current.end_of_day - to.days) }

  
  before_create :catch_uniqueness_exception
  after_update :handle_results
  after_create :run_services, :update_latest_contest_activity, :complete_referral!

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:cardable, :taken)
  end

  def run_services
    OwnerService.new(user, slate: cardable).run(type: :playing)
    ContestService.new(user, resource: cardable).run(type: :playing)
    DrizlyService.new(user, cardable).run(type: :playing)
    IndicativeTrackEventPlayedContestJob.perform_later(user_id)
  end

  def update_sweep_streak
    if saved_change_to_status?(from: 'pending', to: 'win')
      streak = user.streaks.find_or_create_by(type: "SweepStreak")
      streak.update_attributes(current: streak.current += 1)
      if streak.highest < streak.current
        streak.update_attributes(highest: streak.current)
      end
    elsif saved_change_to_status?(from: 'pending', to: 'loss')
      user.streaks.find_or_create_by(type: "SweepStreak").update_attributes(current: 0)
    end
  end

  def update_latest_contest_activity
    user.latest_contest_activity_list << { id: cardable_id, played_at: Time.now, name: cardable.name }
  end

  def update_latest_stats
    user.update_latest_stats(slate: cardable) if saved_change_to_status?
  end

  def handle_results
    update_sweep_streak
    if saved_change_to_status?(from: 'pending', to: 'win')
      create_sweep_records
    elsif saved_change_to_status?(from: 'pending', to: 'loss')
      handle_losers
    end
    update_latest_stats
  end

  def create_sweep_records
    user.sweeps.create(sweepable_id: cardable_id, sweepable_type: "Slate", pick_ids: user.picks.for_slate(cardable_id).map(&:id)) if cardable.class.name == "Slate"
    user.sweeps.create(sweepable_id: cardable_id, sweepable_type: "Quiz", pick_ids: user.choices.for_quiz(cardable_id).map(&:id)) if cardable.class.name == "Quiz"
  end

  def handle_losers
    SendLosingSlateMessageJob.perform_later(user_id, cardable_id) if cardable.class.name == "Slate"
    SendLosingTriviaMessageJob.perform_later(user_id, cardable_id) if cardable.class.name == "Quiz"
  end

  def complete_referral!
    if user.referred_by_id? && user.played_for_first_time?
      user.update_attributes(referral_completed_at: Time.zone.now)
      OwnerService.new(user).run(type: :referral)
      ContestService.new(user).run(type: :referral)
    end
  end

end
class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :win, :loss ]

  validates :slate_id, uniqueness: { scope: :user_id, message: "only 1 Card per Slate" }

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) } 

  around_save :catch_uniqueness_exception
  after_create :run_services, :complete_referral!
  after_update :handle_results

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:slate, :taken)
  end

  def run_services
    AccountService.new(user, slate: slate).run(type: :playing)
    OwnerService.new(user, slate: slate).run(type: :playing)
    ContestService.new(user, slate: slate).run(type: :playing)
    DrizlyService.new(user, slate).run(type: :playing)
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

  def update_latest_stats
    user.update_latest_stats(slate: slate) if saved_change_to_status?
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
    user.sweeps.create(slate_id: slate_id, pick_ids: user.picks.for_slate(slate_id).map(&:id))
  end

  def handle_losers
    SendLosingSlateMessageJob.perform_later(user_id, slate_id)
  end

  def complete_referral!
    if user.referred_by_id? && user.played_for_first_time?
      user.update_attributes(referral_completed_at: Time.zone.now)
      AccountService.new(user).run(type: :referral)
      OwnerService.new(user).run(type: :referral)
      ContestService.new(user).run(type: :referral)
    end
  end

end
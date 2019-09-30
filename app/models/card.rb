class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :win, :loss ]

  validates :slate_id, uniqueness: { scope: :user_id, message: "only 1 Card per Slate" }

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) } 

  around_save :catch_uniqueness_exception
  after_create :send_slate_notification, :complete_referral!
  after_update :run_results, :update_sweep_streak, :update_latest_stats

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:slate, :taken)
  end

  def send_slate_notification
    ContestService.new(user, slate: slate).run(type: :playing)
    DrizlyService.new(user, slate).run(type: :playing)
    # IndicativeTrackEventPlayedContestJob.perform_later(user.id)
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

  def run_results
    if slate.global?
      handle_winners if saved_change_to_status?(from: 'pending', to: 'win')
      send_losing_message if saved_change_to_status?(from: 'pending', to: 'loss')
    else
      handle_winners if saved_change_to_status?(from: 'pending', to: 'win') and slate.resulted?
      send_losing_message if saved_change_to_status?(from: 'pending', to: 'loss') and slate.resulted?
    end
  end

  def handle_winners
    user.sweeps.create(slate_id: slate_id, pick_ids: user.picks.for_slate(slate_id).map(&:id))
    # user.entries.create(slate_id: slate_id, earned_by_id: user.id, reason: Entry::SWEEP)
    # user.entries.unused.each { |entry| entry.update_attributes(slate_id: slate_id, reason: Entry::SWEEP) unless entry.slate_id? }
  end

  def send_losing_message
    SendLosingSlateMessageJob.perform_later(user_id, slate_id)
  end

  def complete_referral!
    if user.referred_by_id? && user.played_for_first_time?
      user.update_attributes(referral_completed_at: Time.zone.now)
      ContestService.new(user).run(type: :referral)
      # IndicativeTrackEventReferredFriendJob.perform_later(user.id)

      # Send notification if promotion is active
      NotifyReferrerJob.perform_later(user.referred_by_id, user.id, Entry::PLAYING) if user.account.rewards.find_by(category: "Contest", active: true).present?
    end
  end

end
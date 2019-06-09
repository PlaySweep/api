class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :win, :loss ]

  validates :slate_id, uniqueness: { scope: :user_id, message: "only 1 Card per Slate" }

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) } 

  around_save :catch_uniqueness_exception
  after_create :send_slate_notification
  after_update :notify_results, :update_user_streaks

  private

  def send_slate_notification
    SendSlateNotificationJob.perform_later(user_id, slate_id)
  end

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:slate, :taken)
  end

  def update_user_streaks
    if slate.global
      if saved_change_to_status?(from: 'pending', to: 'win')
        streak = user.streaks.find_or_create_by(type: "SweepStreak")
        streak.update_attributes(current: streak.current += 1)
        if streak.highest < streak.current
          streak.update_attributes(highest: streak.current) and update_user_stats_for_sweep_leaderboard
        end
      elsif saved_change_to_status?(from: 'pending', to: 'loss')
        user.streaks.find_by(type: "SweepStreak").update_attributes(current: 0)
      end
    end
  end

  def update_user_stats_for_sweep_leaderboard
    board = Board.fetch(leaderboard: :allstar_sweep_leaderboard)
    highest_streak = user.highest_sweep_streak
    board.rank_member(user_id, highest_streak, { name: user.full_name }.to_json)
  end

  def notify_results
    if slate.global?
      send_winning_message if saved_change_to_status?(from: 'pending', to: 'win')
      send_losing_message if saved_change_to_status?(from: 'pending', to: 'loss')
    else
      send_winning_message and initialize_select_winner_process if saved_change_to_status?(from: 'pending', to: 'win') and slate.resulted?
      send_losing_message if saved_change_to_status?(from: 'pending', to: 'loss') and slate.resulted?
    end
  end

  def send_winning_message
    if slate.global?
      user.sweeps.create(slate_id: slate_id, pick_ids: user.picks.for_slate(slate_id).map(&:id))
      SendWinningSlateMessageJob.set(wait_until: 1.minute.from_now.to_datetime).perform_later(user_id, slate_id)
    else
      user.sweeps.create(slate_id: slate_id, pick_ids: user.picks.for_slate(slate_id).map(&:id))
      user.entries.create(slate_id: slate_id)
      user.entries.unused.each { |entry| entry.update_attributes(slate_id: slate_id) unless entry.slate_id? }
      SendWinningSlateMessageJob.set(wait_until: 1.minute.from_now.to_datetime).perform_later(user_id, slate_id)
    end
  end

  def send_losing_message
    SendLosingSlateMessageJob.set(wait_until: 1.minute.from_now.to_datetime).perform_later(user_id, slate_id)
  end

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: 24.hours.from_now.to_datetime).perform_later(slate_id)
  end

end
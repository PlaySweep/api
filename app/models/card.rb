class Card < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :win, :loss ]

  validates :slate_id, uniqueness: { scope: :user_id, message: "only 1 Card per Slate" }

  scope :for_slate, ->(slate_id) { where(slate_id: slate_id) } 

  around_save :catch_uniqueness_exception
  after_create :send_slate_notification
  after_update :update_user_stats_for_sweep_leaderboard

  private

  def send_slate_notification
    SendSlateNotificationJob.perform_later(user_id, slate_id)
  end

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:slate, :taken)
  end

  def update_user_stats_for_sweep_leaderboard
    if slate.global
      board = Board.fetch(leaderboard: :allstar_sweep_leaderboard)
      current_sweep_streak = board.score_for(user_id) || 0
      board.rank_member(user_id.to_s, current_sweep_streak += 1, { name: user.full_name }.to_json) if saved_change_to_status?(from: 'pending', to: 'win')
      board.rank_member(user_id.to_s, 0, { name: user.full_name }.to_json) if saved_change_to_status?(from: 'pending', to: 'loss')
    end
  end

end
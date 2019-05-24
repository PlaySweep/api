class Order < ApplicationRecord
  PENDING, PROCESSED, DELIVERED = 0, 1, 2
  belongs_to :user
  belongs_to :prize

  enum status: [ :pending, :processed, :delivered ]

  validates :prize_id, uniqueness: { scope: :user_id, message: "only 1 per user" }

  scope :for_yesterday, -> { where('created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1) }

  around_save :catch_uniqueness_exception

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:prize, :taken)
  end

end
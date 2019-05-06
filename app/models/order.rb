class Order < ApplicationRecord
  PENDING, PROCESSED, DELIVERED = 0, 1, 2
  belongs_to :user
  belongs_to :prize

  enum status: [ :pending, :processed, :delivered ]

  scope :for_yesterday, -> { where('created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day) }
end
class Order < ApplicationRecord
  PENDING, PROCESSED, DELIVERED = 0, 1, 2
  belongs_to :user
  belongs_to :prize

  enum status: [ :pending, :processed, :delivered ]
end
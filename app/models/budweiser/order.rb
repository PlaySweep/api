class Order < ApplicationRecord
  PENDING, AWAITING_DELIVERY, DELIVERED = 0, 1, 2
  belongs_to :user
  belongs_to :prize

  enum status: [ :pending, :awaiting_delivery, :delivered ]
end
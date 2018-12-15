class Selection < ApplicationRecord
  belongs_to :event

  scope :ordered, -> { order(order: :asc) }
end
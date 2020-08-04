class Option < ApplicationRecord
  belongs_to :item

  scope :ordered, -> { order(order: :asc) }
end
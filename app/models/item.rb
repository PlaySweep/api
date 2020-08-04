class Item < ApplicationRecord
  belongs_to :template
  has_many :options

  scope :ordered, -> { order(order: :asc) }
end
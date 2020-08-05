class Item < ApplicationRecord
  belongs_to :template
  has_many :options, dependent: :destroy

  scope :ordered, -> { order(order: :asc) }
end
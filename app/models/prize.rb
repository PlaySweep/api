class Prize < ApplicationRecord
  belongs_to :prizeable, polymorphic: true
  belongs_to :product
  belongs_to :sku
  has_many :orders, dependent: :destroy

  scope :filtered_by_slate, ->(resource_id) { where(prizeable_type: "Slate", prizeable_id: resource_id) }
end
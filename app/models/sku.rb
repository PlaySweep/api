class Sku < ApplicationRecord
  belongs_to :product

  store_accessor :data, :weight, :unit, :size,
                        :gender, :replacement_value,
                        :packaging_type, :color

  scope :filtered, ->(owner_id) { joins(:product).where('products.owner_id = ? OR products.global = ?', owner_id, true) }
end
class Sku < ApplicationRecord
  belongs_to :product

  store_accessor :data, :weight, :unit, :size,
                        :gender, :replacement_value,
                        :packaging_type, :color

  scope :filtered, ->(product_id) { where(product_id: product_id) }
end
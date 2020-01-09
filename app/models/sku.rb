class Sku < ApplicationRecord
  belongs_to :product

  jsonb_accessor :data,
    weight: [:string, default: nil],
    unit: [:string, default: "lb"],
    size: [:string, default: nil],
    gender: [:string, default: nil],
    replacement_value: [:string, default: nil],
    packaging_type: [:string, default: nil],
    color: [:string, default: nil]
end
class Prize < ApplicationRecord
  belongs_to :slate
  belongs_to :product
  belongs_to :sku
  has_many :orders, dependent: :destroy

  jsonb_accessor :data,
    date: [:string, default: nil]
end
class Prize < ApplicationRecord
  belongs_to :prizeable, polymorphic: true
  belongs_to :product
  belongs_to :sku
  has_many :orders, dependent: :destroy
end
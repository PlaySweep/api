class Prize < ApplicationRecord
  belongs_to :slate
  belongs_to :product
  belongs_to :sku
end
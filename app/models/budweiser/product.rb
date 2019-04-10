class Product < ApplicationRecord
  has_many :skus
  belongs_to :team, foreign_key: :owner_id

  jsonb_accessor :data,
    type: [:string, default: nil]
end
class Product < ApplicationRecord
  has_many :skus
  belongs_to :team, foreign_key: :owner_id

end
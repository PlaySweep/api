class Owner < ApplicationRecord
  belongs_to :account 
  has_many :slates
end
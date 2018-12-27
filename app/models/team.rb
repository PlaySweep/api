class Team < ApplicationRecord
  belongs_to :league, foreign_key: :account_id
  
  has_many :slates
end
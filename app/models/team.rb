class Team < ApplicationRecord
  belongs_to :league
  
  has_many :slates
end
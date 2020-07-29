class Player < ApplicationRecord
  belongs_to :profile
  belongs_to :participant
end
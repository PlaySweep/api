class Player < ApplicationRecord
  belongs_to :owner
  belongs_to :team, foreign_key: :owner_id
  belongs_to :profile
end
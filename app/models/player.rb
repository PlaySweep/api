class Player < ApplicationRecord
  belongs_to :team, foreign_key: :owner_id
  belongs_to :participant

  store_accessor :data, :era
end
class Player < ApplicationRecord
  belongs_to :team, foreign_key: :owner_id
  belongs_to :participant

  jsonb_accessor :data,
  era: [:string, default: nil]
end
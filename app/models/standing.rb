class Standing < ApplicationRecord
  belongs_to :owner
  belongs_to :team, foreign_key: :owner_id

  scope :ordered, -> { order(league: :asc) }
end
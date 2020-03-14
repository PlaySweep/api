class Participant < ApplicationRecord
  belongs_to :team, foreign_key: :owner_id
  belongs_to :slate
  has_one :player

  scope :ordered, -> { order(field: :asc) }
end
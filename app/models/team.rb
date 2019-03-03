class Team < Owner
  belongs_to :league, foreign_key: :account_id

  scope :ordered, -> { order(name: :asc) }

  jsonb_accessor :data,
    entry_image: [:string, default: nil],
    local_image: [:string, default: nil]
end
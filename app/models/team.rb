class Team < Owner
  belongs_to :league, foreign_key: :account_id

  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { data_where(sponsored: true) }

  jsonb_accessor :data,
    entry_image: [:string, default: nil],
    local_image: [:string, default: nil],
    sponsored: [:boolean, default: false]
end
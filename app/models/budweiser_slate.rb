class BudweiserSlate < Slate
  belongs_to :team, foreign_key: :owner_id

  scope :for_owner, ->(owner_id) { where(owner_id: owner_id) } 

  jsonb_accessor :data,
      local: [:boolean, default: false],
      opponent_id: [:integer, default: nil],
      field: [:string, default: nil],
      opponent_pitcher: [:string, default: nil],
      pitcher: [:string, default: nil],
      era: [:string, default: nil],
      opponent_era: [:string, default: nil]

end
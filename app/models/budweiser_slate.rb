class BudweiserSlate < Slate
  belongs_to :team, foreign_key: :owner_id
  belongs_to :winner, foreign_key: :winner_id, class_name: "BudweiserUser", optional: true

  scope :for_owner, ->(owner_id) { where(owner_id: owner_id) } 
  scope :total_entry_count, -> { joins(:cards).count }
  scope :total_entry_count_for_each, -> { left_joins(:cards).group(:id).order('COUNT(cards.id) DESC').count }

  jsonb_accessor :data,
      local: [:boolean, default: false],
      opponent_id: [:integer, default: nil],
      field: [:string, default: nil],
      opponent_pitcher: [:string, default: nil],
      pitcher: [:string, default: nil],
      era: [:string, default: nil],
      opponent_era: [:string, default: nil],
      prizing_category: [:string, default: nil]

end
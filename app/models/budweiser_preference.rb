class BudweiserPreference < Preference
  belongs_to :team, foreign_key: :owner_id

  jsonb_accessor :data,
      owner_id: [:integer, default: nil],
      slate_messaging: [:boolean, default: true]
end
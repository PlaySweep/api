class BudweiserUser < User
  has_one :preference, foreign_key: :user_id

  jsonb_accessor :data,
    referral: [:string, default: "landing_page"]

  scope :count_by_team, ->(team_id) { joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: "#{team_id}") }
  scope :with_referral, ->(referral) { where("users.data->>'referral' = :referral", referral: "#{referral}")}
end
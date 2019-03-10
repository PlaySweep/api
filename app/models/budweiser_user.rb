class BudweiserUser < User
  has_one :preference, foreign_key: :user_id

  jsonb_accessor :data,
    referral: [:string, default: "landing_page"]
end
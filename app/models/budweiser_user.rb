class BudweiserUser < User
  has_one :preference, foreign_key: :user_id
end
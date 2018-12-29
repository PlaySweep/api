class Team < Owner
  belongs_to :league, foreign_key: :account_id
end
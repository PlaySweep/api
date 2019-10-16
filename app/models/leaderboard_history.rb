class LeaderboardHistory < ApplicationRecord
  belongs_to :account, optional: true
  has_many :leaderboard_results
  has_many :users, through: :leaderboard_results
end
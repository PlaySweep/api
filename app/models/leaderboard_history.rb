class LeaderboardHistory < ApplicationRecord
  has_many :leaderboard_results
  has_many :users, through: :leaderboard_results
end
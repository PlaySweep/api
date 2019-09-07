class LeaderboardResult < ApplicationRecord
  belongs_to :user
  belongs_to :leaderboard_history
end
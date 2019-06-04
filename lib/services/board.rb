require 'competition_ranking_leaderboard'

class Board
  def self.fetch leaderboard:
    CompetitionRankingLeaderboard.new(leaderboard)
  end

end
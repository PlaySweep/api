require 'competition_ranking_leaderboard'

class Board
  def self.fetch leaderboard:
    CompetitionRankingLeaderboard.new(leaderboard, Leaderboard::DEFAULT_OPTIONS, { redis_connection: Redis.new(url: ENV["REDIS_URL"])} )
  end

end
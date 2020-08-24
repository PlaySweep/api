require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.development?
  
end

if Rails.env.production?
  # def store_and_cleanup_leaderboard account:
  #   Apartment::Tenant.switch(account.tenant) do
  #     date = DateTime.current.beginning_of_day
  #     if date.tuesday?
  #       leaderboard_name = "week_#{account.current_week - 1}"
  #       leaderboard = Board.fetch(leaderboard: leaderboard_name)
  #       # store leaderboard results into appropriate tables
  #       history = LeaderboardHistory.new(name: "Week #{week}", description: "Most points earned during a weekly period.")
  #       DataMigration.seed_leaderboard_results(leaderboard: leaderboard_name, history: history)
  #       # delete the old weeks leaderboard in redis
  #       leaderboard.delete_leaderboard
  #     end
  #   end
  # end
end

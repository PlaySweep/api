require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.production?

  scheduler.cron '0 12 * * *' do
    AnalyticsJob.perform_later
  end

  scheduler.every '0 10 * * *' do
    puts "Leaderboard cleanup"
    # date = DateTime.current.beginning_of_day
    # account = Account.find_by(name: "NFL")
    # if date.tuesday?
    #   week = account.current_week - 1
    #   leaderboard_name = "week_#{week}"
    #   leaderboard = Board.fetch(leaderboard: leaderboard_name)
    #   # store leaderboard results into appropriate tables
    #   history = LeaderboardHistory.new(name: "Week #{week}", description: "Most points earned during a weekly period.")
    #   DataMigration.seed_leaderboard_results(leaderboard: leaderboard_name, history: history)
    #   # delete the old weeks leaderboard in redis
    #   leaderboard.delete_leaderboard
    # end
  end

end

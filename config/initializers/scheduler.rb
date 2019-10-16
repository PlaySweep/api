require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.production?

  scheduler.cron '0 12 * * *' do
    AnalyticsJob.perform_later
  end

  # scheduler.every '0 10 * * *' do
  #   date = DateTime.current.beginning_of_day
  #   if date.tuesday?
  #     week = date.cweek
  #     leaderboard_name = "week_#{week}"
  #     leaderboard = Board.fetch(leaderboard: leaderboard_name)
  #     # fetch the top points leader for the week
  #     leaderboard.all_members.each do |player|
  #       user = User.find_by(id: player[:member])
  #       if player[:rank] == 1
  #         # send winner message
  #       else
  #         # send a message to all participants updating the weeks results / send message to winner
  #       end
  #     end
  #     # store leaderboard results into appropriate tables
  #     history = LeaderboardHistory.new(name: "Week #{week}", description: "Most points earned during a weekly period.")
  #     DataMigration.seed_leaderboard_results(leaderboard: leaderboard_name, history: history)
  #     # delete the old weeks leaderboard in redis
  #     # leaderboard.delete_leaderboard
  #   end
  # end

end

require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.development?
  @accounts = Account.active

  scheduler.cron '0 1 * * *' do
    @accounts.each { |account| store_leaderboard(account: account) }
  end

  scheduler.cron '0 12 * * *' do
    @accounts.each { |account| fetch_daily_analytics(account: account) }
  end

  def fetch_daily_analytics account:
    Apartment::Tenant.switch(account.tenant) do
      DailyAnalyticsJob.perform_later
    end
  end

  def store_leaderboard account:
    Apartment::Tenant.switch(account.tenant) do
      date = DateTime.current.beginning_of_day
      if date.tuesday?
        reward = Reward.find(5)
        leaderboard_name = "contest_#{reward.name}"
        leaderboard = Board.fetch(leaderboard: leaderboard_name)
        # store leaderboard results into appropriate tables
        leaderboard_history_name = leaderboard_name.split('_').map(&:capitalize).join(' ')
        history = LeaderboardHistory.new(name: leaderboard_history_name, description: "Most points earned for the Race to the Super Bowl.")
        DataMigration.seed_leaderboard_results(leaderboard: leaderboard_name, history: history)
        # delete the old weeks leaderboard in redis
        # leaderboard.delete_leaderboard
      end
    end
  end
end

if Rails.env.production?
  @accounts = Account.active

  # scheduler.cron '0 6 * * 1' do
  #   @accounts.each do |account|
  #     fetch_new_users(account: account)
  #     fetch_player_activity(account: account) 
  #   end
  # end

  # scheduler.cron '0 12 * * *' do
  #   @accounts.each { |account| fetch_daily_analytics(account: account) }
  # end

  # scheduler.cron '0 12 * * 2' do
  #   @accounts.each { |account| fetch_weekly_analytics(account: account) }
  # end

  def fetch_player_activity account:
    Apartment::Tenant.switch(account.tenant) do
      unique_ids_two_weeks_ago = Card.for_quizzes.between_days('quizzes', 14, 8).select(:user_id).distinct.pluck(:user_id)
      unique_ids_one_week_ago = Card.for_quizzes.between_days('quizzes', 7, 1).select(:user_id).distinct.pluck(:user_id)
      returned_user_ids = unique_ids_two_weeks_ago.select { |id| unique_ids_one_week_ago.include?(id) }
      left_user_ids = unique_ids_two_weeks_ago.reject { |id| unique_ids_one_week_ago.include?(id) }
      returned_users = User.where(id: returned_user_ids)
      left_users = User.where(id: left_user_ids)
      new_users = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day - 1)
      WeeklyUserActivityMailer.stats_email(new_users: new_users, returned_users: returned_users, left_users: left_users).deliver_now
    end
  end

  def fetch_daily_analytics account:
    Apartment::Tenant.switch(account.tenant) do
      DailyAnalyticsJob.perform_later
    end
  end

  def fetch_weekly_analytics account:
    Apartment::Tenant.switch(account.tenant) do
      WeeklyAnalyticsJob.perform_later
    end
  end

  def store_and_cleanup_leaderboard account:
    Apartment::Tenant.switch(account.tenant) do
      date = DateTime.current.beginning_of_day
      if date.tuesday?
        leaderboard_name = "week_#{account.current_week - 1}"
        leaderboard = Board.fetch(leaderboard: leaderboard_name)
        # store leaderboard results into appropriate tables
        history = LeaderboardHistory.new(name: "Week #{week}", description: "Most points earned during a weekly period.")
        DataMigration.seed_leaderboard_results(leaderboard: leaderboard_name, history: history)
        # delete the old weeks leaderboard in redis
        leaderboard.delete_leaderboard
      end
    end
  end
end

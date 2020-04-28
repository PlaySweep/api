require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.development?
  
end

if Rails.env.production?
  # @accounts = Account.active

  scheduler.cron '0 6 * * 1' do
    fetch_player_activity(tenant: "budweiser") 
  end

  scheduler.cron '0 12 * * *' do
    fetch_daily_analytics(tenant: "budweiser")
  end

  def fetch_player_activity tenant:
    Apartment::Tenant.switch(tenant) do
      unique_ids_two_weeks_ago = Card.for_quizzes.between_days('quizzes', 14, 8).select(:user_id).distinct.pluck(:user_id)
      unique_ids_one_week_ago = Card.for_quizzes.between_days('quizzes', 7, 1).select(:user_id).distinct.pluck(:user_id)
      returned_user_ids = unique_ids_two_weeks_ago.select { |id| unique_ids_one_week_ago.include?(id) }
      left_user_ids = unique_ids_two_weeks_ago.reject { |id| unique_ids_one_week_ago.include?(id) }
      returned_users = User.where(id: returned_user_ids).sample(25)
      left_users = User.where(id: left_user_ids).sample(25)
      message_count = Notification.where('notifications.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day - 1).size
      new_users = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day - 1).sample(25)
      confirmed_can_users = Hash.new(0)
      can_users = Hash.new(0)
      User.confirmed.where(source: "mlb_scan_lp").each do |user|
        role = user.roles.first
        role ? confirmed_can_users[user.roles.first.name] += 1 : confirmed_can_users['global'] += 1
      end
      User.where(confirmed: false).where(source: "mlb_scan_lp").each do |user|
        role = user.roles.first
        role ? can_users[user.roles.first.name] += 1 : can_users['global'] += 1
      end
      registered_count = confirmed_can_users.size
      unregistered_count = can_users.size
      phone_number_count = User.includes(:phone_numbers).where.not(phone_numbers: { user_id: nil }).size
      WeeklyUserActivityMailer.stats_email(
        new_users: new_users, 
        returned_users: returned_users, 
        left_users: left_users,
        message_count: message_count,
        can_users: can_users,
        confirmed_can_users: confirmed_can_users,
        registered_count: registered_count,
        unregistered_count: unregistered_count,
        phone_number_count: phone_number_count
      ).deliver_now
    end
  end

  def fetch_daily_analytics tenant:
    Apartment::Tenant.switch(tenant) { DailyAnalyticsJob.perform_later }
  end

  # def fetch_weekly_analytics tenant:
  #   Apartment::Tenant.switch(tenant) { WeeklyAnalyticsJob.perform_later }
  # end

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

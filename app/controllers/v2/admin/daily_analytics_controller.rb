class V2::Admin::DailyAnalyticsController < BasicAuthenticationController

  def leaderboard_csv_mailer
    DailyAnalyticsJob.perform_leaderboard_csv
  end

  def fetch_selections_mailer
    DailyAnalyticsJob.perform_fetch_selections
  end
    
  def fetch_orders_mailer
    DailyAnalyticsJob.perform_fetch_orders
  end

  def fetch_skus_mailer
    DailyAnalyticsJob.perform_fetch_skus
  end

  def fetch_teams_mailer
    DailyAnalyticsJob.perform_fetch_teams
  end

  def fetch_products_mailer
    DailyAnalyticsJob.perform_fetch_products
  end
  
  def fetch_users_mailer
    DailyAnalyticsJob.perform_fetch_users
  end


end
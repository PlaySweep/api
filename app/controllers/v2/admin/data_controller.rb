class V2::Admin::DataController < BasicAuthenticationController
  
  def fetch_orders
    FetchOrdersAnalyticsJob.perform_now
  end

  def fetch_player_activity
    FetchPlayerActivityJob.perform_now
  end


end
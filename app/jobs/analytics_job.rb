class AnalyticsJob < ApplicationJob
  @queue = :analytics_job

  def perform
    fetch_user_acquisition_data(day: 1)
    fetch_engagement_data(day: 1)
    fetch_orders_for(day: 1)
    DataMailer.analytics_for(day: 1, email: "ryan@endemiclabs.co").deliver_later
    DataMailer.orders_for(day: 1, email: "ryan@endemiclabs.co").deliver_later
  end

  def fetch_user_acquisition_data day:
    teams = Team.active
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data.csv", "wb") do |csv|
      csv << ["Date", "Team", "Attempted Sign Ups", "Confirmed Users", "Facebook", "Instagram Post", "Instagram Story", "Twitter", "Organic"]
      teams.each do |team|
        team_query = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).joins(:roles).where("roles.resource_id = ?", team.id).uniq
        confirmed_team_query = User.where(confirmed: true).where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).joins(:roles).where("roles.resource_id = ?", team.id).uniq
        csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), team.name, team_query.count, confirmed_team_query.count, for_referral(day: day, resource: team, source: "facebook").count, for_referral(day: day, resource: team, source: "instagrampost").count, for_referral(day: day, resource: team, source: "instagramstory").count, for_referral(day: day, resource: team, source: "twitter").count, for_referral(day: day, resource: team, source: "landing_page").count]
      end
    end
  end

  def for_referral day:, resource:, source:
    User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).joins(:roles).where("roles.resource_id = ?", resource.id).where("users.data->>'referral' = :referral", referral: source)
  end

  def fetch_engagement_data day:
    slate_ids = Slate.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).pluck(:id)
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current).to_date}_engagement_data.csv", "wb") do |csv|
      csv << ["Date", "Contest", "Team", "Type", "Quantity of Entries", "Prize Category", "Prize Name", "Day of Week", "Contest Winners", "Ticket Date"]
      slate_ids.each do |slate_id|
        slate = Slate.find_by(id: slate_id)
        csv << [(DateTime.current).to_date.strftime("%Y%m%d"), slate_id, slate.team.name, slate.local ? "Local" : "Vs", slate.cards.count, slate.prizes.first.product.category, slate.prizes.first.product.name, slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count, slate.prizes.first.date]
      end
    end
  end

  def fetch_orders_for day:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
      Order.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).each do |order|
        csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.product.name, order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
      end
    end
  end

end
require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

unless Rails.env.production?
  scheduler.cron '30 10 * * *' do
    puts "Creating CSV..."
    Apartment::Tenant.switch!('budweiser')
    fetch_user_acquisition_data
    fetch_engagement_data
  end

  scheduler.cron '45 10 * * *' do
    puts "Emailing Ben Analytics..."
    DataMailer.analytics.deliver_now
  end
end

def fetch_user_acquisition_data
  teams = Team.all
  CSV.open("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_acquisition_data.csv", "wb") do |csv|
    csv << ["Date", "Team", "Attempted Sign Ups", "Confirmed Users", "Facebook", "Instagram Post", "Instagram Story", "Twitter", "Organic"]
    teams.each do |team|
      team_query = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:roles).where("roles.resource_id = ?", team.id)
      confirmed_team_query = User.where(confirmed: true).where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:roles).where("roles.resource_id = ?", team.id)
      csv << [(DateTime.current - 1).to_date.strftime("%Y%m%d"), team.name, team_query.count, confirmed_team_query.count, for_referral(resource: team, source: "facebook").count, for_referral(resource: team, source: "instagrampost").count, for_referral(resource: team, source: "instagramstory").count, for_referral(resource: team, source: "twitter").count, for_referral(resource: team, source: "landing_page").count]
    end
  end
end

def for_referral resource:, source:
  User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:roles).where("roles.resource_id = ?", resource.id).where("users.data->>'referral' = :referral", referral: source)
end

def fetch_engagement_data
  slate_ids = Team.all.map do |team|
    Slate.complete.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).filtered(team.id).joins(:cards).group(:id).order(Arel.sql("COUNT(cards.id) DESC")).count.keys
  end.flatten
  CSV.open("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_engagement_data.csv", "wb") do |csv|
    csv << ["Date", "Contest", "Team", "Type", "Quantity of Entries", "Prize", "Day of Week", "Contest Winners"]
    slate_ids.each do |slate_id|
      slate = Slate.find_by(id: slate_id)
      csv << [(DateTime.current - 1).to_date.strftime("%Y%m%d"), slate_id, slate.team.name, slate.local ? "Local" : "Vs", slate.cards.count, slate.prizes.first.product.category, slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count]
    end
  end
end

def fetch_orders
  CSV.open("#{Rails.root}/tmp/orders.csv", "wb") do |csv|
    csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
    Order.all.each do |order|
      csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.product.name, order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
    end
  end
end
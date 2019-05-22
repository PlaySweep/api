require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

unless Rails.env.production?
  scheduler.cron '45 17 * * *' do
    puts "Creating CSV..."
    Apartment::Tenant.switch!('budweiser')
    fetch_user_acquisition_data
    fetch_engagement_data
  end

  scheduler.cron '00 18 * * *' do
    puts "Emailing Ben Analytics..."
    DataMailer.analytics.deliver_now
  end

  scheduler.cron '45 05 * * *' do
    puts "Fetch previous day orders..."
    fetch_orders
  end

  scheduler.cron '00 06 * * *' do
    puts "Send orders..."
    DataMailer.orders_for_yesterday.deliver_now
  end
end

def fetch_user_acquisition_data
  teams = Team.active
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
    Slate.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).filtered(team.id).joins(:cards).group(:id).order(Arel.sql("COUNT(cards.id) DESC")).count.keys
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
  CSV.open("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_orders.csv", "wb") do |csv|
    csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
    Order.pending.for_yesterday.each do |order|
      csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.product.name, order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
    end
  end
end

def fetch_products
  CSV.open("#{Rails.root}/tmp/products.csv", "wb") do |csv|
    csv << ["SKU", "Product Name", "Product Weight (lbs)", "Length (inches)", "Height (inches)", "Width (inches)", "Replacement Value", "Customs Declaration Value", "Country of Origin", "Type of Packaging"]
    Product.where(category: ["Apparel", "Merchandise"]).each do |product|
      csv << [product.skus.first.code, product.name, product.skus.first.weight, "NA", "NA", "NA", "40.00", "40.00", "US", "1"]
    end
  end
end

def fetch_prizes
  CSV.open("#{Rails.root}/tmp/prizes.csv", "wb") do |csv|
    csv << ["Contest ID", "Contest Date", "Team", "Prize", "Winner Name"]
    Slate.finished.each do |slate|
      csv << [slate.id, slate.start_time.to_date.strftime("%Y%m%d"), slate.team.abbreviation, slate.prizes.first ? slate.prizes.first.product.name : "NA", slate.winner_id ? slate.winner.full_name : "NA"]
    end
  end
end

def fetch_contests
  CSV.open("#{Rails.root}/tmp/contests.csv", "wb") do |csv|
    csv << ["name", "start_time", "type", "status", "owner_id", "local", "field", "opponent_id"]
    Slate.all.each do |slate|
      csv << [slate.name, slate.start_time.to_datetime.utc, slate.type, slate.status, slate.owner_id, slate.local, slate.field, slate.opponent_id]
    end
  end
end
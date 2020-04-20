class DailyAnalyticsJob < ApplicationJob
  queue_as :low

  def perform
    fetch_orders
  end

  def fetch_new_users day:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_new_users.csv", "wb") do |csv|
      csv << ["Date", "Name", "Team", "Signed Up", "Source"]
      users = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day)
      users.each do |user|
        csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), user.full_name, user.current_team.abbreviation, user.confirmed, user.source]
      end
    end
    DataMailer.user_acquisition_for(day: day, email: "ben@endemiclabs.co").deliver_now
  end

  def leaderboard_csv
    CSV.open("#{Rails.root}/tmp/world_series_leaderboard.csv", "wb") do |csv|
      csv << ["Rank", "Score", "Name"]
      LeaderboardResult.where(leaderboard_history_id: 3).order(:rank).each do |result|
        csv << [result.rank, result.score, result.user.full_name.empty? ? "#{result.user.first_name}" : "#{result.user.full_name}"]
      end
    end
  end

  def fetch_orders
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Date", "Order Number", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Formatted Address", "Item Title", "SKU", "Size", "Order Weight", "Order Unit", "Shipping Service"]
      Order.pending.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day).each do |order|
        csv << [order.created_at.strftime("%m/%d/%Y"), order.id, order.user.full_name, order.user.email, order.user.phone_number, order.user.addresses.last.try(:line1), order.user.addresses.last.try(:line2), order.user.addresses.last.try(:city), order.user.addresses.last.try(:state), order.user.addresses.last.try(:postal_code), order.user.addresses.last.try(:country), order.user.addresses.last.try(:formatted_address), order.prize.try(:product).try(:name), order.prize.sku.code, order.prize.sku.size, order.prize.sku.weight, order.prize.sku.unit, "Endemic Labs - #{order.user.account.name}"]
      end
    end
    DataMailer.orders_to(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_winners day:
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_winners.csv", "wb") do |csv|
      csv << ["User ID", "Name", "Email", "Zipcode", "Prize Won", "Contest", "Contest Date"]
      Sweep.where('sweeps.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day).each do |sweep|
        csv << [sweep.user_id, sweep.user.full_name, sweep.user.email, sweep.user.zipcode, sweep.slate.prizes.first.try(:product).try(:name), sweep.slate.name, sweep.slate.start_time.strftime("%m/%d/%Y")]
      end
    end
    DataMailer.winners_to(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_skus
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv", "wb") do |csv|
      csv << ["ID", "Product Name", "Description", "Code", "Size"]
      skus = Sku.all
      skus.each do |sku|
        csv << [sku.id, sku.product.name, sku.product.description, sku.code, sku.size]
      end
    end
    DataMailer.skus(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_products
    CSV.open("#{Rails.root}/tmp/products.csv", "wb") do |csv|
      csv << ["ID", "Team", "Name", "Category"]
      products = Product.active.order(owner_id: :asc)
      products.each do |product|
        csv << [product.id, product.team ? product.team.name : "Global", product.name, product.category]
      end
    end
    DataMailer.products(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_active_teams
    CSV.open("#{Rails.root}/tmp/teams.csv", "wb") do |csv|
      csv << ["ID", "Name"]
      teams = Team.active.order(id: :asc)
      teams.each do |team|
        csv << [team.id, team.name]
      end
    end
    DataMailer.teams(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_with_source users:
    hash = Hash.new(0)
    users.each do |user|
      role = user.roles.first
      role ? hash[user.roles.first.name] += 1 : hash['global'] += 1
    end
    hash.keys.each { |key| puts "#{key} - #{hash[key]}"}
  end

end
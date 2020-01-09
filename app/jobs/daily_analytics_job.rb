class DailyAnalyticsJob < ApplicationJob
  queue_as :low

  def perform
    fetch_new_users(day: 1)
    fetch_engagement_data(day: 1)
    fetch_gopuff
    fetch_orders
    fetch_winners(day: 1)
    fetch_losers(day: 1)
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

  def fetch_engagement_data day:
    slate_ids = Slate.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).pluck(:id)
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv", "wb") do |csv|
      csv << ["Date", "Contest Number", "Team", "Type", "Quantity of Entries", "Prize Category", "Prize Name", "Day of Week", "Contest Winners", "Ticket Date"]
      slate_ids.each do |slate_id|
        slate = Slate.find_by(id: slate_id)
        csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), Slate.finished_contest_count_for(slate.owner_id).size, slate.team.abbreviation, slate.cards.count, slate.prizes.first.try(:product).try(:category), slate.prizes.first.try(:product).try(:name), slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count, slate.prizes.first.try(:date)]
      end
    end
    DataMailer.engagement_analytics_for(day: day, email: "ben@endemiclabs.co").deliver_now
  end

  def leaderboard_csv
    CSV.open("#{Rails.root}/tmp/world_series_leaderboard.csv", "wb") do |csv|
      csv << ["Rank", "Score", "Name"]
      LeaderboardResult.where(leaderboard_history_id: 3).order(:rank).each do |result|
        csv << [result.rank, result.score, result.user.full_name.empty? ? "#{result.user.first_name}" : "#{result.user.full_name}"]
      end
    end
  end

  def drizly_winners users:
    CSV.open("#{Rails.root}/tmp/drizly_winners.csv", "wb") do |csv|
      csv << ["ID", "Name", "Email", "Zipcode", "Contest Date"]
      users.each do |user|
        csv << [user.id, user.full_name, user.email, user.zipcode, user.sweeps.last.slate.start_time]
      end
    end
  end

  def users_for team:
    users = User.joins(:roles).where('roles.resource_id = ?', team.id)
    CSV.open("#{Rails.root}/tmp/#{team.abbreviation.downcase}_players.csv", "wb") do |csv|
      csv << ["Name", "Email", "Zipcode"]
      users.each do |user|
        csv << [user.full_name, user.email, user.zipcode]
      end
    end
  end

  def fetch_slates day:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_slates.csv", "wb") do |csv|
      csv << ["Start Time", "Team", "Contest", "Prize"]
      Slate.where('slates.start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).each do |order|
        csv << [slate.start_time.strftime("%m/%d/%Y"), slate.team.abbreviation, slate.name, slate.prizes.first ? slate.prizes.first.try(:product).try(:name) : "NA"]
      end
    end
  end

  def fetch_orders
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
      Order.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 14, DateTime.current.end_of_day).each do |order|
        csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.try(:product).try(:name), order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
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

  def fetch_losers day:
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_losers.csv", "wb") do |csv|
      csv << ["User ID", "Name", "Email", "Zipcode", "Prize Won", "Contest", "Contest Date"]
      cards = Card.joins(:slate).where('slates.start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day)
      cards.loss.each do |card|
        csv << [card.user_id, card.user.full_name, card.user.email, card.user.zipcode, card.slate.prizes.first ? card.slate.prizes.first.try(:product).try(:name) : "NA", card.slate.name, card.slate.start_time.strftime("%m/%d/%Y")]
      end
    end
    DataMailer.losers_to(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_gopuff
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_gopuff.csv", "wb") do |csv|
      csv << ["Date", "Name", "Email", "Zipcode", "Source"]
      users = User.where('source ilike ?', '%gopuff%')
      users.each do |user|
        csv << [user.created_at.strftime("%Y%m%d"), user.full_name, user.email, user.zipcode, user.source]
      end
    end
    DataMailer.gopuff_to(email: "ben@endemiclabs.co").deliver_now
  end

  def fetch_skus
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv", "wb") do |csv|
      csv << ["Product Name", "Code", "Size"]
      skus = Sku.all
      skus.each do |sku|
        csv << [sku.product.name, sku.code, sku.size]
      end
    end
    DataMailer.products(email: "budweisersweep@endemiclabs.co").deliver_now
  end

end
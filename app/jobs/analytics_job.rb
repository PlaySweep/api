class AnalyticsJob < ApplicationJob
  queue_as :low

  def perform
    fetch_all_acquisitions_by(day: 1)
    fetch_orders
    fetch_winners(day: 1)
    DataMailer.analytics_for(day: 1, email: "ben@endemiclabs.co").deliver_later
    DataMailer.orders_to(email: "budweisersweep@endemiclabs.co").deliver_later
    DataMailer.winners_to(email: "budweisersweep@endemiclabs.co").deliver_later
  end

  def merge_acquisition day:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_final_acquisition.csv", "wb", write_headers: true, headers: ["Date", "Team", "Count", "Source"]) do |csv|
      Dir["tmp/#{(DateTime.current - day).to_date}_acquisition_data_for_*.csv"].each do |path|  # for each of your csv files
        CSV.foreach(path, headers: true, return_headers: false) do |row| # don't output the headers in the rows
          csv << row # append to the final file
        end
      end
    end
  end

  def fetch_all_acquisitions_by day:
    teams = Team.active
    teams.each do |team|
      create_team_acquisition_sheet_by(day: day, team: team, source: "facebook")
      create_team_acquisition_sheet_by(day: day, team: team, source: "twitter")
      create_team_acquisition_sheet_by(day: day, team: team, source: nil)
      create_team_acquisition_sheet_by(day: day, team: team, source: "#{team.abbreviation.downcase}_lp")
      create_team_acquisition_sheet_by(day: day, team: team, source: "#{team.abbreviation.downcase}_lp_2")
    end
    merge_acquisition(day: day)
  end

  def create_team_acquisition_sheet_by day:, team:, source:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data_for_#{team.abbreviation.downcase}_#{source}.csv", "wb") do |csv|
      csv << ["Date", "Team", "Count", "Source"]
      csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), team.abbreviation, for_referral(day: day, source: source).size, source.nil? ? "other" : source]
    end
  end

  def for_referral day:, source:
    User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).where("users.data->>'referral' = :referral", referral: source)
  end

  def drizly_winners users:
    CSV.open("#{Rails.root}/tmp/drizly_winners.csv", "wb") do |csv|
      csv << ["Name", "Email", "Zipcode"]
      users.each do |user|
        csv << [user.full_name, user.email, user.zipcode]
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

  def fetch_engagement_data day:
    slate_ids = Slate.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).pluck(:id)
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv", "wb") do |csv|
      csv << ["Date", "Contest Number", "Team", "Type", "Quantity of Entries", "Prize Category", "Prize Name", "Day of Week", "Contest Winners", "Ticket Date"]
      slate_ids.each do |slate_id|
        slate = Slate.find_by(id: slate_id)
        csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), Slate.finished_contest_count_for(slate.owner_id).size, slate.team.abbreviation, slate.cards.count, slate.prizes.first.product.category, slate.prizes.first.product.name, slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count, slate.prizes.first.date]
      end
    end
  end

  def fetch_orders
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
      Order.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 14, DateTime.current.end_of_day).each do |order|
        csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.product.name, order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
      end
    end
  end

  def fetch_winners day:
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_winners.csv", "wb") do |csv|
      csv << ["User ID", "Name", "Email", "Zipcode", "Prize Won", "Contest", "Contest Date"]
      Sweep.where('sweeps.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day).each do |sweep|
        csv << [sweep.user_id, sweep.user.full_name, sweep.user.email, sweep.user.zipcode, sweep.slate.prizes.first.product.name, sweep.slate.name, sweep.slate.start_time.strftime("%m/%d/%Y")]
      end
    end
  end

end
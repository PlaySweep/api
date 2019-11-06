class AnalyticsJob < ApplicationJob
  queue_as :low

  def perform
    fetch_all_acquisitions_by(day: 1)
    fetch_engagement_data(day: 1)
    fetch_orders
    fetch_winners(day: 1)
    fetch_losers(day: 1)
    DataMailer.analytics_for(day: 1, email: "ben@endemiclabs.co").deliver_later
    DataMailer.orders_to(email: "budweisersweep@endemiclabs.co").deliver_later
    DataMailer.winners_to(email: "budweisersweep@endemiclabs.co").deliver_later
    DataMailer.losers_to(email: "budweisersweep@endemiclabs.co").deliver_later
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
      create_team_acquisition_sheet_by(day: day, team: team, source: "referred")
      create_team_acquisition_sheet_by(day: day, team: team, source: nil)
      create_team_acquisition_sheet_by(day: day, team: team, source: "#{team.abbreviation.downcase}_lp")
      create_team_acquisition_sheet_by(day: day, team: team, source: "#{team.abbreviation.downcase}_lp_2")
    end
    merge_acquisition(day: day)
  end

  def create_team_acquisition_sheet_by day:, team:, source:
    CSV.open("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data_for_#{team.abbreviation.downcase}_#{source}.csv", "wb") do |csv|
      csv << ["Date", "Team", "Count", "Source"]
      csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), team.abbreviation, for_referral(day: day, team: team, source: source).size, source.nil? ? "other" : source]
    end
  end

  def for_referral day:, team:, source:
    User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day - day).where(confirmed: true).data_where(referral: source).joins(:roles).where("roles.resource_id = ?", team.id)
  end

  def drizly_winners users:
    CSV.open("#{Rails.root}/tmp/drizly_winners.csv", "wb") do |csv|
      csv << ["ID", "Name", "Email", "Zipcode"]
      users.each do |user|
        csv << [user.id, user.full_name, user.email, user.zipcode]
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
        csv << [(DateTime.current - day).to_date.strftime("%Y%m%d"), Slate.finished_contest_count_for(slate.owner_id).size, slate.team.abbreviation, slate.cards.count, slate.prizes.first.try(:product).try(:category), slate.prizes.first.try(:product).try(:name), slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count, slate.prizes.first.try(:date)]
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
  end

  def fetch_winners day:
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_winners.csv", "wb") do |csv|
      csv << ["User ID", "Name", "Email", "Zipcode", "Prize Won", "Contest", "Contest Date"]
      Sweep.where('sweeps.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day).each do |sweep|
        csv << [sweep.user_id, sweep.user.full_name, sweep.user.email, sweep.user.zipcode, sweep.slate.prizes.first.try(:product).try(:name), sweep.slate.name, sweep.slate.start_time.strftime("%m/%d/%Y")]
      end
    end
  end

  def fetch_losers day:
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_losers.csv", "wb") do |csv|
      csv << ["User ID", "Name", "Email", "Zipcode", "Prize Won", "Contest", "Contest Date"]
      cards = Card.joins(:slate).where('slates.start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - day, DateTime.current.end_of_day)
      cards.loss.each do |card|
        csv << [card.user_id, card.user.full_name, card.user.email, card.user.zipcode, card.slate.prizes.first ? card.slate.prizes.first.try(:product).try(:name) : "NA", card.slate.name, card.slate.start_time.strftime("%m/%d/%Y")]
      end
    end
  end

  def number_of_playing_promotions_used_by_week level:
    promotions = Promotion.where(type: "DrizlyPromotion", used: true, category: "Playing", level: level).where('updated_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day) 
    promotions.size
  end

  def number_of_playing_promotions_used_all_time level:
    promotions = Promotion.where(type: "DrizlyPromotion", used: true, category: "Playing", level: level) 
    promotions.size
  end

  def number_of_sweep_promotions_used_by_week level:
    slates = Slate.finished.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 5, DateTime.current.end_of_day) 
    promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true, level: level).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
    promotions.size
  end

  def number_of_sweep_promotions_used_all_time level:
    slates = Slate.finished
    promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true, level: level).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
    promotions.size
  end

end
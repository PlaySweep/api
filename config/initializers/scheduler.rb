require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '0 22 * * *' do
  puts "Creating CSV"
  Apartment::Tenant.switch!('budweiser')
  fetch_user_acquisition_data
  fetch_engagement_data
end

def fetch_user_acquisition_data
  teams = Team.active
  CSV.open("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_acquisition_data.csv", "wb") do |csv|
    csv << ["Date", "Team", "Attempted Sign Ups", "Confirmed Users", "Facebook", "Instagram", "Twitter", "Organic"]
    teams.each do |team|
      team_query = BudweiserUser.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: "#{team.id}")
      confirmed_team_query = BudweiserUser.where(confirmed: true).where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: "#{team.id}")
      csv << [(DateTime.current - 1).to_date.strftime("%Y%m%d"), team.name, team_query.count, confirmed_team_query.count, for_referral(resource: team, source: "facebook").count, for_referral(resource: team, source: "instagram").count, for_referral(resource: team, source: "twitter").count, for_referral(resource: team, source: "landing_page").count]
    end
  end
end

def for_referral resource:, source:
  BudweiserUser.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: "#{resource.id}").where("users.data->>'referral' = :referral", referral: source)
end

def fetch_engagement_data
  slate_ids = Team.active.map do |team|
    BudweiserSlate.complete.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 1, DateTime.current.end_of_day - 1).for_owner(team.id).joins(:cards).group(:id).order(Arel.sql("COUNT(cards.id) DESC")).count.keys
  end.flatten
  CSV.open("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_engagement_data.csv", "wb") do |csv|
    csv << ["Date", "Contest", "Team", "Type", "Quantity of Entries", "Prize", "Day of Week", "Contest Winners"]
    slate_ids.each do |slate_id|
      slate = BudweiserSlate.find_by(id: slate_id)
      csv << [(DateTime.current - 1).to_date.strftime("%Y%m%d"), slate_id, slate.team.name, slate.local ? "Local" : "Vs", slate.cards.count, slate.prizing_category, slate.start_time.strftime("%A").capitalize, slate.cards.map(&:status).reject { |status| status == 'loss' }.count]
    end
  end
end
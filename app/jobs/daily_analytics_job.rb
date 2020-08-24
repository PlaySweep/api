class DailyAnalyticsJob < ApplicationJob
  queue_as :low

  def perform
  end

  def leaderboard_csv
    CSV.open("#{Rails.root}/tmp/world_series_leaderboard.csv", "wb") do |csv|
      csv << ["Rank", "Score", "Name"]
      LeaderboardResult.where(leaderboard_history_id: 3).order(:rank).each do |result|
        csv << [result.rank, result.score, result.user.full_name.empty? ? "#{result.user.first_name}" : "#{result.user.full_name}"]
      end
    end
  end

  def fetch_skus
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv", "wb") do |csv|
      csv << ["Sku ID", "Team", "Category", "Product ID", "Name", "Description", "Code", "Size"]
      skus = Sku.order(code: :asc)
      skus.each do |sku|
        csv << [sku.id, sku.product.global? ? "Global" : sku.product.team.abbreviation, sku.product.category, sku.product_id, sku.product.name, sku.product.description, sku.code, sku.size]
      end
    end
    DataMailer.skus(email: "ben@endemiclabs.co").deliver_now
  end

  def fetch_teams
    CSV.open("#{Rails.root}/tmp/teams.csv", "wb") do |csv|
      csv << ["ID", "Name", "Abbreviation"]
      teams = Team.active.order(name: :asc)
      teams.each do |team|
        csv << [team.id, team.name, team.abbreviation]
      end
    end
    DataMailer.teams(email: "ben@endemiclabs.co").deliver_now
  end

  def fetch_products
    CSV.open("#{Rails.root}/tmp/products.csv", "wb") do |csv|
      csv << ["ID", "Team", "Name", "Category"]
      products = Product.active.order(owner_id: :asc)
      products.each do |product|
        csv << [product.id, product.team ? product.team.name : "Global", product.name, product.category]
      end
    end
    DataMailer.products(email: "ben@endemiclabs.co").deliver_now
  end

  def fetch_users users:
    CSV.open("#{Rails.root}/tmp/users.csv", "wb") do |csv|
      csv << ["FB uuid", "Name", "Email", "Phone number"]
      users.each do |user|
        csv << [" #{user.facebook_uuid}", user.full_name, user.email, user.phone_number.nil? ? "" : user.phone_number.number]
      end
    end
    DataMailer.users(email: "ben@endemiclabs.co").deliver_now
  end

end
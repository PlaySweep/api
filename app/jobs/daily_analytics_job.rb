class DailyAnalyticsJob < ApplicationJob
  queue_as :low

  def perform
    fetch_orders
  end

  def leaderboard_csv
    CSV.open("#{Rails.root}/tmp/world_series_leaderboard.csv", "wb") do |csv|
      csv << ["Rank", "Score", "Name"]
      LeaderboardResult.where(leaderboard_history_id: 3).order(:rank).each do |result|
        csv << [result.rank, result.score, result.user.full_name.empty? ? "#{result.user.first_name}" : "#{result.user.full_name}"]
      end
    end
  end

  def fetch_selections
    CSV.open("#{Rails.root}/tmp/selections.csv", "wb") do |csv|
      csv << ["ID", "Description"]
      Selection.all.each do |selection|
        csv << [selection.id, selection.description]
      end
    end
    DataMailer.selections_to(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_orders
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Date", "Order Number", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Formatted Address", "Item Title", "SKU", "Size", "Order Weight", "Order Unit", "Shipping Service", "Source"]
      Order.pending.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day).each do |order|
        csv << [order.created_at.strftime("%m/%d/%Y"), order.id, order.user.full_name, order.user.email, order.user.phone_number, order.user.addresses.last.try(:line1), order.user.addresses.last.try(:line2), order.user.addresses.last.try(:city), order.user.addresses.last.try(:state), order.user.addresses.last.try(:postal_code), order.user.addresses.last.try(:country), order.user.addresses.last.try(:formatted_address), order.prize.try(:product).try(:name), order.prize.sku.code, order.prize.sku.size, order.prize.sku.weight, order.prize.sku.unit, "Endemic Labs - #{order.user.account.name}", order.prize.prizeable.name]
      end
    end
    DataMailer.orders_to(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def build_email_contact_list users:
    CSV.open("#{Rails.root}/tmp/email_contact_list.csv", "wb") do |csv|
      csv << %w[email first_name last_name address_line_1 address_line_2 city state_province_region postal_code country]
      users.each do |user|
        csv << [user.email, user.first_name, user.last_name, user.addresses.any? ? user.addresses.first.line1 : "", user.addresses.any? ? user.addresses.first.line2 : "", user.addresses.any? ? user.addresses.first.city : "", user.addresses.any? ? user.addresses.first.state : "", user.addresses.any? ? user.addresses.first.postal_code : "", user.addresses.any? ? user.addresses.first.country : ""]
      end
    end
    DataMailer.send_contacts_list(email: "ryan@endemiclabs.co").deliver_now
  end

  def fetch_skus
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv", "wb") do |csv|
      csv << ["Sku ID", "Team", "Category", "Product ID", "Name", "Description", "Code", "Size"]
      skus = Sku.order(code: :asc)
      skus.each do |sku|
        csv << [sku.id, sku.product.global? ? "Global" : sku.product.team.abbreviation, sku.product.category, sku.product_id, sku.product.name, sku.product.description, sku.code, sku.size]
      end
    end
    DataMailer.skus(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_teams
    CSV.open("#{Rails.root}/tmp/teams.csv", "wb") do |csv|
      csv << ["ID", "Name", "Abbreviation"]
      teams = Team.active.order(name: :asc)
      teams.each do |team|
        csv << [team.id, team.name, team.abbreviation]
      end
    end
    DataMailer.teams(email: "budweisersweep@endemiclabs.co").deliver_now
  end

  def fetch_products
    CSV.open("#{Rails.root}/tmp/products.csv", "wb") do |csv|
      csv << ["ID", "Team", "Name", "Category"]
      products = Product.active.order(owner_id: :asc)
      products.each do |product|
        csv << [product.id, product.team ? product.team.name : "Global", product.name, product.category]
      end
    end
    DataMailer.products(email: "ryan@endemiclabs.co").deliver_now
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
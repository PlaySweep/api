class FetchOrdersAnalyticsJob < ApplicationJob
  
  def perform
    fetch_orders
  end
  
  def fetch_orders
    CSV.open("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv", "wb") do |csv|
      csv << ["Order Date", "Order Number", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Formatted Address", "Item Title", "SKU", "Size", "Order Weight", "Order Unit", "Shipping Service", "Source"]
      Order.pending.where('orders.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day).each do |order|
        csv << [order.created_at.strftime("%m/%d/%Y"), order.id, order.user.full_name, order.user.email, order.user.phone_number, order.user.addresses.last.try(:line1), order.user.addresses.last.try(:line2), order.user.addresses.last.try(:city), order.user.addresses.last.try(:state), order.user.addresses.last.try(:postal_code), order.user.addresses.last.try(:country), order.user.addresses.last.try(:formatted_address), order.prize.try(:product).try(:name), order.prize.sku.code, order.prize.sku.size, order.prize.sku.weight, order.prize.sku.unit, "Endemic Labs - #{order.user.account.name}", order.prize.prizeable.name]
      end
    end
    DataMailer.orders_to(email: "nate@endemiclabs.co").deliver_now
  end

end
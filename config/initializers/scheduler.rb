require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.production?

  scheduler.cron '05 16 * * *' do
    AnalyticsJob.perform_later
  end

end

def fetch_orders
  CSV.open("#{Rails.root}/tmp/orders.csv", "wb") do |csv|
    csv << ["Order Number", "Order Date", "Recipient Name", "Email", "Phone", "Street Line 1", "Street Line 2", "City", "State/Province", "Zip/Postal Code", "Country", "Item Title", "SKU", "Order Weight", "Order Unit"]
    Order.pending.each do |order|
      csv << [order.id, order.created_at.strftime("%m/%d/%Y"), order.user.full_name, order.user.email, order.user.phone_number, order.user.shipping["line1"], order.user.shipping["line2"], order.user.shipping["city"], order.user.shipping["state"], order.user.shipping["postal_code"], order.user.shipping["country"], order.prize.product.name, order.prize.sku.code, order.prize.sku.weight, order.prize.sku.unit]
    end
  end
end

class DataMailer < ApplicationMailer
  default from: "ryan@endemiclabs.co"

  def analytics
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_acquisition_data.csv")
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - 1).to_date}_acquisition_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    attachments["#{(DateTime.current - 1).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Analytics - #{(DateTime.current - 1).to_date}",
      body: "Attached below."
    )
  end

  def analytics_for_today
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_acquisition_data.csv")
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current).to_date}_acquisition_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    attachments["#{(DateTime.current).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Analytics - #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def analytics_for day
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data.csv")
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - day).to_date}_acquisition_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    attachments["#{(DateTime.current - day).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Analytics - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def products
    products_csv = File.read("#{Rails.root}/tmp/products.csv")
    attachments["#{Rails.root}/tmp/products.csv"] = { mime_type: 'text/csv', content: products_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Products CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def prizes
    prizes_csv = File.read("#{Rails.root}/tmp/prizes.csv")
    attachments["#{Rails.root}/tmp/prizes.csv"] = { mime_type: 'text/csv', content: prizes_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Prizes CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def orders
    orders_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_orders.csv")
    attachments["#{Rails.root}/tmp/#{(DateTime.current).to_date}_orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Orders CSV #{(DateTime.current - 1).to_date}",
      body: "Attached below."
    )
  end

  def orders_for_today to:
    orders_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_orders.csv")
    attachments["#{Rails.root}/tmp/#{(DateTime.current).to_date}_orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: to,
      subject: "Orders CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def orders_for_yesterday
    orders_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_orders.csv")
    attachments["#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Orders CSV #{(DateTime.current - 1).to_date}",
      body: "Attached below."
    )
  end
end

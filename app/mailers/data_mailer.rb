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

  def national_analytics
    national_engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_national_engagement_data.csv")
    attachments["#{(DateTime.current - 1).to_date}_national_engagement_data.csv"] = { mime_type: 'text/csv', content: national_engagement_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Analytics - #{(DateTime.current - 1).to_date}",
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

  def orders
    orders_csv = File.read("#{Rails.root}/tmp/orders.csv")
    attachments["#{Rails.root}/tmp/orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: "ben@endemiclabs.co",
      subject: "Orders CSV #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def orders_to email:
    orders_csv = File.read("#{Rails.root}/tmp/orders.csv")
    attachments["#{Rails.root}/tmp/orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: email,
      subject: "Orders CSV #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

end

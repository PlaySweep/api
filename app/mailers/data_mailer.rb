class DataMailer < ApplicationMailer
  default from: "ryan@endemiclabs.co"

  def analytics_for day:, email:
    account = Account.first
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data.csv")
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - day).to_date}_acquisition_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    attachments["#{(DateTime.current - day).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Analytics - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def acquistion day:, email:
    account = Account.first
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data.csv")
    attachments["#{(DateTime.current - day).to_date}_acquistion_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Acquistion - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def engagement day:, email:
    account = Account.first
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - day).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Engagement - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def engagement email:
    account = Account.first
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Engagement - #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def products email:
    account = Account.first
    products_csv = File.read("#{Rails.root}/tmp/products.csv")
    attachments["#{Rails.root}/tmp/products.csv"] = { mime_type: 'text/csv', content: products_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Products CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def prizes email:
    account = Account.first
    prizes_csv = File.read("#{Rails.root}/tmp/prizes.csv")
    attachments["#{Rails.root}/tmp/prizes.csv"] = { mime_type: 'text/csv', content: prizes_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Prizes CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def all_orders_to email:
    account = Account.first
    orders_csv = File.read("#{Rails.root}/tmp/orders.csv")
    attachments["#{Rails.root}/tmp/orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Orders CSV #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def orders_to email:
    account = Account.first
    orders_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Orders CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end
end

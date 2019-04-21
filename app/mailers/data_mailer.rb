class DataMailer < ApplicationMailer
  default from: "ryan@endemiclabs.co"

  def analytics
    mail(
      to: "ben@endemiclabs.co",
      content_type: "text/html",
      subject: "Analytics - #{(DateTime.current - 1).to_date}",
      body: "Attached below.",
      attachments: [
        {
          filename: "#{(DateTime.current - 1).to_date}_acquisition_data.csv",
          content: File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_acquisition_data.csv")
        },
        {
          filename: "#{(DateTime.current - 1).to_date}_engagement_data.csv",
          content: File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_engagement_data.csv")
        },
      ]
    )
  end
end

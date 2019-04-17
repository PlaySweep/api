class AnalyticsMailer < ApplicationMailer
  default from: "ryan@endemiclabs.co"
  # def welcome_email
  #   mail(
  #     to: "ben@endemiclabs.com",
  #     content_type: "text/html",
  #     subject: "Analytics",
  #     attachments: {
  #       filename: 'analytics.csv',
  #       content: File.read("#{Rails.root}/tmp/#{(DateTime.current - 1).to_date}_acquisition_data.csv")
  #     }
  #   )
  # end
  def test
    mail(
      to: "ben@endemiclabs.co",
      content_type: "text/html",
      subject: "Analytics",
      body: "Test 123",
      attachments: {
        filename: 'acquisition_data.csv',
        content: File.read("#{Rails.root}/tmp/acquisition_data.csv")
      }
    )
  end
end

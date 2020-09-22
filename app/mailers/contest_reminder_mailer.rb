class ContestReminderMailer < ApplicationMailer

  def notify(users)
    personalizations = users.map do |user|
      {
        to: [
          {
            email: user.email
          }
        ],
        dynamic_template_data: {
          first_name: user.first_name
        }
      }
    end
    template_id = "d-bf056091d3234f09ba4006f5fcef5ff5"
    from_email = "hi@thebudweisersweep.com"
    data = {
      personalizations: personalizations,
      from: { email: from_email },
      template_id: template_id
    }

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._("send").post(request_body: data)
  end
end
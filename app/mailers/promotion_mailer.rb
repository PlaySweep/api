class PromotionMailer < ApplicationMailer
  default from: "hi@sweepgames.io"

  def notify(users)
    @users = users
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
    template_id = "d-cff7093515cc4ed59d1ec0829986c2ca"
    data = {
      personalizations: personalizations,
      from: { email: "hi@sweepgames.io" },
      template_id: template_id
    }

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._("send").post(request_body: data)
  end
end
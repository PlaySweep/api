class GoPuffMailer < ApplicationMailer
  default from: "hi@thebudlightsweeps.com"

  def notify(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Hi #{@user.first_name}, we have one more way for you to get to Super Bowl LIV 👀",
      content_type: "text/html"
    )
  end
end
class GoPuffMailer < ApplicationMailer
  default from: "hi@thebudlightsweeps.com"

  def notify(user)
    @user = user

    mail(
      to: @user.email,
      subject: "There's one more way to get to Super Bowl LIV, #{user.first_name} 🏈!",
      content_type: "text/html"
    )
  end
end
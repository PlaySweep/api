class DrizlyPlayMailer < ApplicationMailer
  default from: "hi@thebudlightsweeps.com"

  def notify(user, promotion)
    @user, @promotion = user, promotion

    mail(
      to: @user.email,
      subject: "🍺 Cheers, #{@user.first_name}.",
      content_type: "text/html"
    )
  end
end

class DrizlyPlayMailer < ApplicationMailer
  default from: "hi@thebudlightsweeps.com"

  def notify(user)
    @user = user

    mail(
      to: @user.email,
      subject: "🍺 Here's your $10 Drizly, #{@user.first_name}."
    )
  end
end

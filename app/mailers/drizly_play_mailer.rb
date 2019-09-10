class DrizlyPlayMailer < ApplicationMailer
  default from: "hi@thebudlightsweeps.com"

  def notify(user, promotion)
    @user, @promotion = user, promotion

    mail(
      to: @user.email,
      subject: "🍺 Here's your #{promotion.value_in_format} Drizly, #{@user.first_name}."
    )
  end
end

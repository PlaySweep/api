class SendWinningTriviaMessageJob < ApplicationJob
  queue_as :low

  def perform user_id, quiz_id
    user = User.find(user_id)
    quiz = Quiz.find(quiz_id)
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      },
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    winning_quiz_copy = user.account.copies.where(category: "Winning Quiz").sample.message
    interpolated_winning_quiz_copy = winning_quiz_copy % { first_name: user.first_name, prize_name: "Budweiser Bottle Opener", drawing_prize_name: quiz.prize.product.name }
    FacebookMessaging::Standard.deliver(
      user: user,
      message: interpolated_winning_quiz_copy,
      notification_type: "NO_PUSH"
    )
    product = Product.find_by(default: true)
    card = user.cards.win.find_by(cardable_id: quiz.id)
    prize = card.prizes.create(product_id: product.id, sku_id: product.skus.first.id)
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Confirm Now",
      url: "#{ENV["WEBVIEW_URL"]}/prize_confirmation/#{prize.id}/#{user.slug}",
      notification_type: "NO_PUSH"
    )
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  end
end
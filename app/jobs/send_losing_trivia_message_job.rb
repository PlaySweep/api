class SendLosingTriviaMessageJob < ApplicationJob
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
    losing_quiz_copy = user.account.copies.where(category: "Losing Quiz").sample.message
    interpolated_losing_quiz_copy = losing_quiz_copy % { first_name: user.first_name }

    FacebookMessaging::Standard.deliver(
      user: user, 
      message: interpolated_losing_quiz_copy, 
      notification_type: "NO_PUSH"
    )
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  end
end
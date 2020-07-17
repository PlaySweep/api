class SendLosingTriviaMessageJob < ApplicationJob
  queue_as :low

  def perform user_id, quiz_id
    user = User.find(user_id)
    quiz = Quiz.find(quiz_id)
    # TODO Handle a new way to message
  end
end
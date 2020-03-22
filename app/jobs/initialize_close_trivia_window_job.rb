class InitializeCloseTriviaWindowJob < ApplicationJob
  queue_as :critical

  def perform quiz_id
    quiz = Quiz.find_by(id: quiz_id)
    quiz.ended! if quiz.live?
  end
end
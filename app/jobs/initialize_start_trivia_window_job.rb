class InitializeStartTriviaWindowJob < ApplicationJob
  queue_as :critical

  def perform quiz_id
    quiz = Quiz.find_by(id: quiz_id)
    quiz.live! unless quiz.nil? || quiz.ended?
    quiz.team.quizzes.inactive.ascending.first.upcoming! if quiz.team.quizzes.inactive.ascending.first
  end
end
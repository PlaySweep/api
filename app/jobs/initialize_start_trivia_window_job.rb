class InitializeStartTriviaWindowJob < ApplicationJob
  queue_as :critical

  def perform quiz_id
    quiz = Quiz.find_by(id: quiz_id)
    quiz.pending! unless quiz.nil? || quiz.complete?
    if quiz.team.nil?
      Quiz.unfiltered.ascending.inactive.first.try(:upcoming!)
    else
      quiz.team.quizzes.inactive.ascending.first.upcoming! if quiz.team.quizzes.inactive.ascending.first
    end
  end
end
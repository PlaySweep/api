class InitializeStartTriviaWindowJob < ApplicationJob
  queue_as :critical

  def perform quiz_id
    quiz = Quiz.find_by(id: quiz_id)
    quiz.pending! unless quiz.nil? || quiz.complete?
    if quiz.owner_id?
      quiz.owner.quizzes.inactive.ascending.first.upcoming! if quiz.owner.quizzes.inactive.ascending.first
      Quiz.unfiltered.ascending.inactive.first.try(:upcoming!)
    else
      Quiz.unfiltered.ascending.inactive.first.try(:upcoming!)
    end
  end
end
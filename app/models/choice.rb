class Choice < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :question
  belongs_to :user
  belongs_to :answer

  enum status: [ :pending, :win, :loss ]

  scope :for_quiz, ->(question_id) { joins(:question).where('questions.quiz_id = ?', question_id) }

  after_create :create_card_when_finished

  def create_card_when_finished
    Card.create(user_id: user_id, cardable_type: "Quiz", cardable_id: question.quiz_id) if user.completed_selections_for(resource: question.quiz)
  end
end
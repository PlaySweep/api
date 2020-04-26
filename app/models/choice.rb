class Choice < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :question
  belongs_to :user
  belongs_to :answer

  enum status: [ :pending, :win, :loss ]

  validates :question_id, uniqueness: { scope: :user_id, message: "only 1 per question" }

  scope :for_quiz, ->(question_id) { joins(:question).where('questions.quiz_id = ?', question_id) }

  around_save :catch_uniqueness_exception
  after_update :run_results
  after_create :create_card_when_finished

  def create_card_when_finished
    Card.create(user_id: user_id, cardable_type: "Quiz", cardable_id: question.quiz_id) if user.completed_selections_for(resource: question.quiz)
  end

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:answer, :taken)
  end

  def run_results
    if saved_change_to_status?(from: 'pending', to: 'win')
      ContestService.new(user, resource: question.quiz).run(type: :pick)
    end
  end

end
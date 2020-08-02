class Choice < ApplicationRecord
  PENDING, WIN, LOSS = 0, 1, 2
  belongs_to :question
  belongs_to :user
  belongs_to :answer

  enum status: [ :pending, :win, :loss ]

  validates :question_id, uniqueness: { scope: :user_id, message: "only 1 per question" }

  scope :for_quiz, ->(question_id) { joins(:question).where('questions.quiz_id = ?', question_id) }

  around_save :catch_uniqueness_exception

  private

  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    self.errors.add(:answer, :taken)
  end

end
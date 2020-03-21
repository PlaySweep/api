class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, dependent: :destroy
  has_many :choices, dependent: :destroy
  has_many :question_sessions, dependent: :destroy

  scope :ordered, -> { order(order: :asc) }
  scope :most_recent, -> { order(order: :desc) }
  scope :descending, -> { joins(:quiz).merge(Quiz.descending) }
  scope :unfiltered, -> { joins(:quiz).merge(Quiz.unfiltered) }

  def winners
    answers.winners
  end

end
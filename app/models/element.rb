class Element < ApplicationRecord
  scope :for_slates, -> { where(type: "SlateElement") }
  scope :for_quizzes, -> { where(category: "QuizElement") }

  scope :with_entries, -> { where(category: "Entry") }
  scope :with_erasers, -> { where(category: "Eraser") }

  scope :active, -> { where(active: true) }
end
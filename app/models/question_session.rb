class QuestionSession < ApplicationRecord
  STARTED, OVER = 0, 1
  belongs_to :user
  belongs_to :question

  enum status: [ :started, :over ]
end
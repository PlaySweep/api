class QuestionSession < ApplicationRecord
  STARTED, OVER = 0, 1
  belongs_to :user
  belongs_to :question

  enum status: [ :started, :over ]

  before_update :calculate_and_update_speed

  private

  def calculate_and_update_speed
    if saved_change_to_status?(from: 'started', to: 'over')
      speed = (updated_at - created_at).round(1)
      self.speed = speed
    end
  end
end
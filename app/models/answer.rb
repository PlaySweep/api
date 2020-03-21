class Answer < ApplicationRecord
  PENDING, WINNER, LOSER = 0, 1, 2
  belongs_to :question

  enum status: [ :pending, :winner, :loser ]

  before_destroy :destroy_associated_choices

  scope :winners, -> { where(status: WINNER) }
  scope :losers, -> { where(status: LOSER) }
  scope :ordered, -> { order(order: :asc) }

  def selected current_user
    id == current_user.choices.where(question_id: question_id).where(answer_id: id).try(:first).try(:answer_id)
  end

  private

  def destroy_associated_choices
    Choice.where(answer_id: id).destroy_all
  end

end
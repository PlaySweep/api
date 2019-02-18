class Selection < ApplicationRecord
  belongs_to :event

  scope :ordered, -> { order(order: :asc) }

  def selected current_user
    id == current_user.picks.where(event_id: event_id).where(selection_id: id).try(:first).try(:selection_id)
  end
end
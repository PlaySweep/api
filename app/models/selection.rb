class Selection < ApplicationRecord
  belongs_to :event

  before_destroy :destroy_associated_picks

  scope :ordered, -> { order(order: :asc) }

  def selected current_user
    id == current_user.picks.where(event_id: event_id).where(selection_id: id).try(:first).try(:selection_id)
  end

  private

  def destroy_associated_picks
    Pick.where(selection_id: id).destroy_all
  end
end
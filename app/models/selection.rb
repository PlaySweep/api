class Selection < ApplicationRecord
  PENDING, WINNER, LOSER = 0, 1, 2
  belongs_to :event

  before_destroy :destroy_associated_picks
  after_update :check_associated_event_status

  scope :winners, -> { where(status: WINNER) }
  scope :losers, -> { where(status: LOSER) }
  scope :ordered, -> { order(order: :asc) }

  enum status: [ :pending, :winner, :loser ]

  store_accessor :data, :category

  def selected current_user
    id == current_user.picks.where(event_id: event_id).where(selection_id: id).try(:first).try(:selection_id)
  end

  private

  def destroy_associated_picks
    Pick.where(selection_id: id).destroy_all
  end

  def check_associated_event_status
    if event.selections.pending.empty?
      self.event.ready!
    else
      self.event.incomplete! unless event.incomplete?
    end
  end
end
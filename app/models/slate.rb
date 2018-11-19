class Slate < ApplicationRecord
  INACTIVE, PENDING, COMPLETE = 0, 1, 2

  after_update_commit :update_associations

  has_many :events
  has_many :users, through: :events
  has_many :cards

  enum status: [ :inactive, :pending, :complete ]

  def progress current_user_id
    if users.find_by(id: current_user_id).nil?
      :unstarted
    elsif users.find_by(id: current_user_id).present? && cards.find_by(user_id: current_user_id).nil?
      :started
    elsif users.find_by(id: current_user_id).present? && cards.find_by(user_id: current_user_id).present?
      :finished
    end
  end

  private

  def update_associations
    update_picks if saved_change_to_status?(to: 'complete')
  end

  def update_picks
    events.each do |event|
      Pick.where(selection_id: event.winner_ids).map(&:win!)
      Pick.where(selection_id: event.loser_ids).map(&:loss!)
    end
  end

end
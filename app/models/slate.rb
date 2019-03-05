class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE = 0, 1, 2, 3

  belongs_to :owner

  has_many :events, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards

  enum status: [ :inactive, :pending, :started, :complete ]

  def progress current_user_id
    if users.find_by(id: current_user_id).present? && cards.find_by(user_id: current_user_id).user.picks.where(event_id: [events.map(&:id)]).size == events.size
      :complete
    elsif users.find_by(id: current_user_id).present? && cards.find_by(user_id: current_user_id).user.picks.where(event_id: [events.map(&:id)]).size != events.size
      :unfinished
    elsif users.find_by(id: current_user_id).nil?
      :new
    end
  end

  def events_are_completed?
    events.size == events.where(status: 1).size
  end

  def winner_ids
    events.map(&:winners).map(&:id)
  end

  def opponent
    return nil unless opponent_id
    Team.find_by(id: opponent_id)
  end

end
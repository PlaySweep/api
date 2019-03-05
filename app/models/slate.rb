class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE = 0, 1, 2, 3

  belongs_to :owner

  has_many :events, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards

  enum status: [ :inactive, :pending, :started, :complete ]

  scope :available, -> { where(status: [1, 2]) }

  def progress current_user_id
    if started?
      :started
    elsif users.find_by(id: current_user_id).present? && cards.find_by(user_id: current_user_id).user.picks.where(event_id: [events.map(&:id)]).size == events.size
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

  private

  def result_slate
    send_winning_message and send_losing_message if saved_change_to_status?(to: 'complete') and events_are_completed?
  end

  def change_status
    StartSlateJob.set(wait_until: start_time).perform_later(id) if saved_change_to_status?(to: 'pending')
  end

  def send_winning_message
    #TODO create a sweep record
    cards.win.each do |card|
      SendWinningSlateMessageJob.perform_later(card.user_id)
      card.user.sweeps.create(date: DateTime.current, pick_ids: card.user.picks.for_slate(id).map(&:id))
    end
  end

  def send_losing_message
    cards.loss.each { |card| SendLosingSlateMessageJob.perform_later(card.user_id)}
  end

end
class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE = 0, 1, 2, 3

  belongs_to :owner

  has_many :events, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards, dependent: :destroy

  enum status: [ :inactive, :pending, :started, :complete ]

  scope :available, -> { where(status: [1, 2]) }
  scope :descending, -> { order(start_time: :desc) }
  scope :for_the_month, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day + 7) }

  after_update :result_slate
  after_update :change_status
  after_update :winner_selected?

  jsonb_accessor :data,
      winner_id: [:integer, default: nil]

  def progress current_user_id
    if started?
      :started
    elsif users.find_by(id: current_user_id).present?
      if cards.find_by(user_id: current_user_id).try(:user).try(:picks)
        if cards.find_by(user_id: current_user_id).try(:user).try(:picks).where(event_id: [events.map(&:id)]).size == events.size
          :complete
        end
      end
    elsif users.find_by(id: current_user_id).present?
      if cards.find_by(user_id: current_user_id).try(:user).try(:picks)
        if cards.find_by(user_id: current_user_id).try(:user).try(:picks).where(event_id: [events.map(&:id)]).size != events.size
          :unfinished
        end
      end
    elsif users.find_by(id: current_user_id).nil?
      :new
    end
  end

  def events_are_completed?
    events.size == events.where(status: 1).size
  end

  def winners
    events.map(&:selections).map(&:winners).flatten
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
    difference = (start_time.in_time_zone - DateTime.current.in_time_zone).to_f
    minutes_until_start = (difference * 24 * 60).to_i
    StartSlateJob.set(wait: minutes_until_start).perform_later(id) if saved_change_to_status?(from: 'inactive', to: 'pending')
  end

  def winner_selected?
    entries.each { |entry| entry.update_attributes(used: true) } if saved_change_to_winner_id?
  end

  def send_winning_message
    cards.win.each do |card|
      SendWinningSlateMessageJob.perform_later(card.user_id)
      card.user.entries.create(slate_id: id) and card.user.entries.unused.each { |entry| entry.update_attributes(slate_id: id) } and card.user.sweeps.create(slate_id: id, pick_ids: card.user.picks.for_slate(id).map(&:id))
    end
  end

  def send_losing_message
    cards.loss.each { |card| SendLosingSlateMessageJob.perform_later(card.user_id)}
  end

end
class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE, DONE = 0, 1, 2, 3, 4

  resourcify

  belongs_to :team, foreign_key: :owner_id
  belongs_to :winner, foreign_key: :winner_id, class_name: "User", optional: true

  has_many :events, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards, dependent: :destroy
  has_many :prizes

  enum status: [ :inactive, :pending, :started, :complete ]

  scope :available, -> { where(status: [1, 2]) }
  scope :descending, -> { order(start_time: :desc) }
  scope :for_the_month, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day + 7) }
  scope :filtered, ->(owner_id) { where(owner_id: owner_id) } 
  scope :total_entry_count, -> { joins(:cards).count }
  scope :total_entry_count_for_each, -> { left_joins(:cards).group(:id).order('COUNT(cards.id) DESC').count }
  
  after_update :change_status, :result_slate, :start_winner_confirmation_window

  jsonb_accessor :data,
    winner_id: [:integer, default: nil],
    local: [:boolean, default: false],
    opponent_id: [:integer, default: nil],
    field: [:string, default: nil],
    opponent_pitcher: [:string, default: nil],
    pitcher: [:string, default: nil],
    era: [:string, default: nil],
    opponent_era: [:string, default: nil],
    previous_user_ids: [:string, array: true, default: []]

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
    (send_winning_message && send_losing_message) and initialize_select_winner_process if saved_change_to_status?(to: 'complete') and events_are_completed?
  end

  def change_status
    StartSlateJob.set(wait_until: start_time.to_datetime).perform_later(id) if saved_change_to_status?(from: 'inactive', to: 'pending')
  end

  def settle_entries
    entries.each { |entry| entry.update_attributes(used: true) } if saved_change_to_status?(to: 'done')
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

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: (start_time.tomorrow.beginning_of_day + 9.hours).to_datetime).perform_later(id)
  end

  def start_winner_confirmation_window
    SendWinnerConfirmationJob.perform_later(winner_id) and HandleConfirmationWindowJob.set(wait_until: 48.hours.from_now.to_datetime).perform_later(id) if saved_change_to_winner_id?
  end

end
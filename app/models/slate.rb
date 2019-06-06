class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE, DONE, POSTPONED = 0, 1, 2, 3, 4, 5

  resourcify

  belongs_to :owner, optional: true
  belongs_to :team, foreign_key: :owner_id, optional: true
  belongs_to :winner, foreign_key: :winner_id, class_name: "User", optional: true

  has_many :events, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards, dependent: :destroy
  has_many :prizes, dependent: :destroy

  enum status: [ :inactive, :pending, :started, :complete, :done, :postponed ]

  scope :for_admin, -> { where(status: [0, 1, 2]) }
  scope :available, -> { where(status: [1, 2]) }
  scope :finished, -> { where(status: [3, 4]) }
  scope :ascending, -> { order(start_time: :asc) }
  scope :descending, -> { order(start_time: :desc) }
  scope :since_last_week, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 5, DateTime.current.end_of_day + 2) }
  scope :for_the_month, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day + 7) }
  scope :filtered, ->(role_ids) { where(owner_id: role_ids) } 
  scope :unfiltered, -> { data_where(global: true) } 
  scope :total_entry_count, -> { joins(:cards).count }
  scope :total_entry_count_for_each, -> { left_joins(:cards).group(:id).order('COUNT(cards.id) DESC').count }
  
  after_update :change_status, :result_slate, :settle_entries, :start_winner_confirmation_window

  accepts_nested_attributes_for :prizes

  jsonb_accessor :data,
    winner_id: [:integer, default: nil],
    local: [:boolean, default: false],
    opponent_id: [:integer, default: nil],
    field: [:string, default: nil],
    opponent_pitcher: [:string, default: nil],
    pitcher: [:string, default: nil],
    previous_user_ids: [:string, array: true, default: []],
    standing: [:string, default: nil],
    opponent_standing: [:string, default: nil],
    result: [:string, default: nil],
    score: [:string, default: nil],
    global: [:boolean, default: false],
    team_id: [:integer, default: nil]

  def next
    team.slates.where("start_time > ?", start_time).last
  end

  def prev
    team.slates.where("start_time < ?", start_time).last
  end

  def progress current_user_id
    if cards.find_by(user_id: current_user_id, slate_id: id)
      :complete
    else
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

  def resulted?
    (result && score).present?
  end

  private

  def result_slate
    (send_winning_message && send_losing_message) and initialize_select_winner_process if saved_change_to_status?(from: 'started', to: 'complete') and (resulted? && events_are_completed?)
  end

  def change_status
    StartSlateJob.set(wait_until: start_time.to_datetime).perform_later(id) if saved_change_to_status?(from: 'inactive', to: 'pending')
  end

  def settle_entries
    entries.each { |entry| entry.update_attributes(used: true) } if saved_change_to_status?(to: 'done')
  end

  def send_winning_message
    cards.win.each do |card|
      card.user.entries.create(slate_id: id)
      card.user.entries.unused.each { |entry| entry.update_attributes(slate_id: id) unless entry.slate_id? }
      card.user.sweeps.create(slate_id: id, pick_ids: card.user.picks.for_slate(id).map(&:id))
      SendWinningSlateMessageJob.set(wait_until: 1.minute.from_now.to_datetime).perform_later(card.user_id, card.slate_id)
    end
  end

  def send_losing_message
    cards.loss.each { |card| SendLosingSlateMessageJob.set(wait_until: 1.minute.from_now.to_datetime).perform_later(card.user_id, card.slate_id)}
  end

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: 24.hours.from_now.to_datetime).perform_later(id)
  end

  def start_winner_confirmation_window
    SendWinnerConfirmationJob.perform_later(id, winner_id) and HandleConfirmationWindowJob.set(wait_until: 48.hours.from_now.to_datetime).perform_later(id) if winner_id? and saved_change_to_winner_id?
  end

end
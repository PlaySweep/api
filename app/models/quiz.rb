class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :cards, as: :cardable, dependent: :destroy
  has_many :prizes, as: :prizeable, dependent: :destroy

  store_accessor :data, :winner_id

  enum status: [ :inactive, :upcoming, :pending, :complete ]

  scope :filtered, ->(role_ids) { where(owner_id: role_ids).or(Quiz.where(owner_id: nil)) }
  scope :inactive, -> { where(status: 0) }
  scope :available, -> { where(status: [1, 2]) }
  scope :finished, -> { where(status: 3) }
  scope :ascending, -> { order(start_time: :asc) }
  scope :descending, -> { order(start_time: :desc) } 
  scope :since_last_week, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 10, DateTime.current.end_of_day) }
  scope :unfiltered, -> { where(owner_id: nil) } 

  after_update :initialize_starting_process, :initialize_closing_process, :initialize_select_winner_process, :start_winner_confirmation_window
  
  def winner
    User.find_by(id: winner_id)
  end

  def has_winner?
    winner.present?
  end

  def winners
    questions.map(&:answers).map(&:winners).flatten
  end

  def owner
    return Owner.find_by(id: owner_id)
    Owner.find_by(id: team_id)
  end

  def team
    return Team.find_by(id: owner_id)
    Team.find_by(id: team_id)
  end

  def prize
    return prizes.first if prizes.any?
  end

  def played? current_user_id
    cards.find_by(user_id: current_user_id, cardable_id: id).present?
  end

  private

  def initialize_starting_process
    InitializeStartTriviaWindowJob.set(wait_until: start_time.to_datetime).perform_later(id) if saved_change_to_status?(from: 'inactive', to: 'upcoming')
  end

  def initialize_closing_process
    InitializeCloseTriviaWindowJob.set(wait_until: end_time.to_datetime).perform_later(id) if saved_change_to_status?(from: 'upcoming', to: 'pending')
  end

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: 1.hour.from_now).perform_later(id, "Quiz") if saved_change_to_status?(from: 'pending', to: 'complete')
  end

  def start_winner_confirmation_window
    if complete? && saved_change_to_data?
      winners_card = cards.find_by(user_id: winner_id)
      SendWinnerConfirmationJob.perform_later(winner_id, prize.id, winners_card.id) if winner_id.present? && prize
      HandleConfirmationWindowJob.set(wait_until: 24.hours.from_now).perform_later(id, "Quiz")
    end
  end

end
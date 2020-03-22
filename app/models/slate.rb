class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED, COMPLETE, DONE, POSTPONED = 0, 1, 2, 3, 4, 5

  resourcify

  belongs_to :contest, optional: true
  has_many :events, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards, as: :cardable, dependent: :destroy
  has_many :prizes, as: :prizeable, dependent: :destroy
  has_many :participants, dependent: :destroy

  store_accessor :data, :winner_id, :local, :field,
                        :opponent_id, :previous_user_ids,
                        :result, :score, :team_id

  enum status: [ :inactive, :pending, :started, :complete, :done, :postponed ]

  scope :for_admin, -> { where(status: [0, 1, 2]) }
  scope :available, -> { where(status: [1, 2]) }
  scope :finished, -> { where(status: [3, 4]) }
  scope :ascending, -> { order(start_time: :asc) }
  scope :descending, -> { order(start_time: :desc) }
  scope :since_last_week, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 10, DateTime.current.end_of_day) }
  scope :for_the_month, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 30, DateTime.current.end_of_day) }
  scope :filtered, ->(role_ids) { where(owner_id: role_ids, contest_id: nil) } 
  scope :unfiltered, -> { where.not(contest_id: nil) } 
  scope :finished_contest_count_for, ->(owner_id) { finished.where(owner_id: owner_id) } 
  scope :total_entry_count, -> { joins(:cards).count }
  scope :total_entry_count_for_each, -> { left_joins(:cards).group(:id).order('COUNT(cards.id) DESC').count }
  
  after_update :change_status, :run_results, :start_winner_confirmation_window

  accepts_nested_attributes_for :prizes

  def prize
    return prizes.first if prizes.any?
  end

  def next
    team.slates.where("start_time > ?", start_time).last
  end

  def prev
    team.slates.where("start_time < ?", start_time).last
  end

  def played? current_user_id
    cards.find_by(user_id: current_user_id, cardable_id: id).present?
  end

  def number_of_correct_answers_for current_user_id
    card = cards.find_by(user_id: current_user_id, cardable_id: id)
    if card
      case card.cardable.class.name
      when "Slate"
        data = card.user.picks.where(event_id: card.cardable.events.map(&:id))
      when "Quiz"
        data = card.user.choices.where(question_id: card.cardable.questions.map(&:id))
      end
      data.win.count
    end
  end

  def winner
    User.find_by(id: winner_id)
  end

  def has_winner?
    winner.present?
  end

  def user_sweeped?(user_id)
    cards.win.find_by(user_id: user_id).present?
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

  def owner
    return Owner.find_by(id: owner_id)
    Owner.find_by(id: team_id)
  end

  def team
    return Team.find_by(id: owner_id)
    Team.find_by(id: team_id)
  end

  def ticket_prizing?
    prizes.joins(:product).where("products.category = ?", "Tickets").any?
  end

  def current_week
    date = start_time.to_datetime
    return date.last_week.cweek if date.monday? && owner.account.has_abnormal_weekly_calendar?
    date.cweek
  end

  def current_day
    date = start_time.to_datetime
    date.cwday
  end

  def display_week
    weeks_list = { 
      week_44: "Week 9",
      week_45: "Week 10",
      week_46: "Week 11",
      week_47: "Week 12",
      week_48: "Week 13",
      week_49: "Week 14",
      week_50: "Week 15",
      week_51: "Week 16",
      week_52: "Week 17",
      week_53: "Wild Card Weekend",
      week_54: "Divisional Round",
      week_55: "Conference Championship",
    }
    week = "week_#{current_week}".to_sym
    weeks_list[week]
  end

  private

  def run_results
    ResultCardsJob.perform_later(id) if saved_change_to_status?(from: 'started', to: 'complete') and events_are_completed?
    initialize_select_winner_process unless prizes.empty?
  end

  def change_status
    StartSlateJob.set(wait_until: start_time.to_datetime).perform_later(id) if saved_change_to_status?(from: 'inactive', to: 'pending')
  end

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: 1.hour.from_now.to_datetime).perform_later(id, "Slate") if saved_change_to_status?(from: 'started', to: 'complete')
  end

  def start_winner_confirmation_window
    if complete? && saved_change_to_winner_id?
      SendWinnerConfirmationJob.perform_later(winner_id, prize.id) if winner_id? && prize
      HandleConfirmationWindowJob.set(wait_until: 24.hours.from_now.to_datetime).perform_later(id, "Slate")
    end
  end

end
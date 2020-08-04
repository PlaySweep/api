class Slate < ApplicationRecord
  INACTIVE, PENDING, STARTED = 0, 1, 2
  READY, COMPLETE, DONE = 3, 4, 5
  POSTPONED, DEACTIVATED = 6, 7

  resourcify

  belongs_to :contest, optional: true
  belongs_to :winner, class_name: "User", foreign_key: :current_winner_id, optional: true
  has_many :events, dependent: :destroy
  has_many :users, through: :events
  has_many :picks, through: :users
  has_many :cards, as: :cardable, dependent: :destroy
  has_many :prizes, as: :prizeable, dependent: :destroy
  has_many :participants, dependent: :destroy

  store_accessor :data, :previous_user_ids, :result, :score

  enum status: [ :inactive, :pending, :started, :ready, :complete, :done, :postponed, :deactivated ]

  scope :for_admin, -> { where(status: [0, 1, 2]) }
  scope :editable, -> { where(status: [0, 1]) }
  scope :available, -> { where(status: [1]) }
  scope :finished, -> { where(status: [4, 5]) }
  scope :ascending, -> { order(start_time: :asc) }
  scope :descending, -> { order(start_time: :desc) }
  scope :recent, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 2, DateTime.current.end_of_day) }
  scope :since_last_week, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 10, DateTime.current.end_of_day) }
  scope :for_the_month, -> { where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 30, DateTime.current.end_of_day) }
  scope :filtered, ->(role_ids) { where(owner_id: role_ids) } 
  scope :unfiltered, -> { where(owner_id: nil).where.not(contest_id: nil) } 
  scope :finished_contest_count_for, ->(owner_id) { finished.where(owner_id: owner_id) } 
  scope :total_entry_count, -> { joins(:cards).count }
  scope :total_entry_count_for_each, -> { left_joins(:cards).group(:id).order('COUNT(cards.id) DESC').count }
  
  after_update :set_background_job, :clear_background_job, :update_background_job, :run_results

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

  def has_winner?
    winner.present?
  end

  def user_sweeped?(user_id)
    cards.win.find_by(user_id: user_id).present?
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
    ResultCardsJob.perform_later(id) if saved_change_to_status?(from: 'ready', to: 'complete')
    initialize_select_winner_process unless prizes.empty?
  end

  def set_background_job
    if saved_change_to_status?(from: 'inactive', to: 'pending')
      scheduled_job = StartSlateJob.set(wait_until: start_time.to_datetime).perform_later(id)
      BackgroundJob.create(job_name: "StartSlateJob", job_id: scheduled_job.job_id, resource: "Slate", resource_id: id)
    end
  end

  def clear_background_job
    if saved_change_to_status?(from: 'pending', to: 'inactive')
      background_job = BackgroundJob.queued.find_by(resource_id: id)
      queued_status = ActiveJob::Status.get(background_job.job_id)
      queued_status.update({ cancelled: true })
    end
  end

  def update_background_job
    if pending? && saved_change_to_start_time?
      background_job = BackgroundJob.queued.find_by(resource_id: id)
      queued_status = ActiveJob::Status.get(background_job.job_id)
      queued_status.update({ cancelled: true })

      scheduled_job = StartSlateJob.set(wait_until: start_time.to_datetime).perform_later(id)
      BackgroundJob.create(job_name: "StartSlateJob", job_id: scheduled_job.job_id, resource: "Slate", resource_id: id)
    end
  end

  def initialize_select_winner_process
    SelectWinnerJob.set(wait_until: 2.hours.from_now).perform_later(id, "Slate") if saved_change_to_status?(from: 'ready', to: 'complete')
  end

  def start_winner_confirmation_window
    if saved_change_to_current_winner_id?
      winners_card = cards.find_by(user_id: current_winner_id)
      SendWinnerConfirmationJob.perform_later(current_winner_id, prize.id, winners_card.try(:id)) if current_winner_id? && prize
      HandleConfirmationWindowJob.set(wait_until: 24.hours.from_now).perform_later(id, "Slate")
    end
  end

end
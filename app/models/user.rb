class User < ApplicationRecord
  SWEEP = :sweep
  REFERRAL_THRESHOLD = [3, 10, 50]
  include Redis::Objects

  hash_key :stats_hash_key
  list :latest_stats_list, maxlength: 3, marshal: true
  list :latest_contest_activity_list, maxlength: 3, marshal: true

  rolify

  store_accessor :data, :notification_preference

  belongs_to :account, optional: true
  belongs_to :league, foreign_key: :account_id, optional: true
  belongs_to :referred_by, class_name: "User", optional: true
  has_many :addresses, dependent: :destroy
  has_many :elements, class_name: "UserElement"
  has_many :sweeps, dependent: :destroy
  has_many :streaks, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :choices, dependent: :destroy
  has_many :events, through: :picks
  has_many :cards, dependent: :destroy
  has_many :referrals, -> { where.not(referral_completed_at: nil).where('created_at > ?', ReferralMilestone::START_DATE) }, class_name: "User", foreign_key: :referred_by_id
  has_many :slates, through: :cards, source: :cardable, source_type: "Slate"
  has_many :quizzes, through: :cards, source: :cardable, source_type: "Quiz"
  has_many :entries, dependent: :destroy
  has_many :leaderboard_results
  has_many :leaderboards, through: :leaderboard_results, source: "leaderboard_history", dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :promotions, foreign_key: :used_by, dependent: :destroy
  has_many :phone_numbers, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_one :location, dependent: :destroy

  accepts_nested_attributes_for :elements

  before_create :set_slug, :set_referral_code
  after_update :create_or_update_location
  after_update :run_badge_service, :run_notification_service

  scope :for_account, ->(name) { joins(:account).where("accounts.name = ?", name) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  scope :for_owner, ->(owner_id) { joins(:roles).where('roles.resource_id = ?', owner_id) }
  scope :with_source, ->(source) { where(source: source) }
  scope :most, ->(association) { left_joins(association.to_sym).group(:id).order("COUNT(#{association.to_s}.id) DESC") }

  validates :slug, :referral_code, uniqueness: true

  def update_latest_stats slate:
    event_ids = events.where(slate_id: slate.id).map(&:id)
    wins = picks.joins(:selection).where(event_id: event_ids).where('selections.status = ?', Pick::WIN).size
    losses = picks.joins(:selection).where(event_id: event_ids).where('selections.status = ?', Pick::LOSS).size
    latest_stats_list << { slate_id: slate.id, wins: wins, losses: losses }
  end

  def stats
    stats_hash_key.value.to_dot
  end

  def latest_stats
    latest_stats_list.map(&:to_dot)
  end

  def latest_contest_activity
    latest_contest_activity_list.map(&:to_dot)
  end

  def current_team
    roles.find_by(resource_type: "Team").try(:resource) || Team.find_by(name: account.app_name)
  end

  def current_team_is_default?
    default_team_id = Team.find_by(name: account.app_name).id
    current_team.id == default_team_id
  end

  def eligible_for_drizly?
    reward = current_team.rewards.active.find_by(name: "Drizly", category: "Playing")
    rule = DrizlyRule.find_by(name: location.try(:state), category: "Playing", eligible: true)
    reward && rule.present?
  end

  def eligible_for_prize? slate:
    distance = Haversine.distance(slate.team.coordinates, coordinates).to_miles
    distance <= 75
  end

  def coordinates
    if location
      [location.lat, location.long].map(&:to_f)
    else
      [30.3368251, -97.7545452]
    end
  end

  def has_never_played?
    cards.size == 0
  end

  def played_for_first_time?
    cards.size == 1
  end

  def won_for_first_time?
    sweeps.size == 1
  end

  def filtered_ids
    roles.map(&:resource_id)
  end

  def highest_sweep_streak
    streaks.find_by(type: "SweepStreak").try(:highest) || 0
  end

  def highest_pick_streak
    streaks.find_by(type: "PickStreak").try(:highest) || 0
  end

  def current_sweep_streak
    streaks.find_by(type: "SweepStreak").try(:current) || 0
  end

  def current_pick_streak
    streaks.find_by(type: "PickStreak").try(:current) || 0
  end

  def self.by_name full_name
    full_name = full_name.split(' ')
    find_by_first_name_and_last_name(full_name[0], full_name[-1])
  end

  def full_name
    first_name && last_name ? "#{first_name} #{last_name}" : ""
  end

  def abbreviated_name
    first_name && last_name ? "#{first_name} #{last_name[0]}." : ""
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def default_image
    account.image
  end

  def won_slate? slate
    event_ids = events.where(slate_id: slate.id).map(&:id)
    picks_for_slate = picks.where(event_id: event_ids).map(&:selection_id)
    picks_for_slate.sort == slate.winners.map(&:id).uniq.sort
  end

  def won_quiz? quiz
    question_ids = questions.where(quiz: quiz.id).map(&:id)
    picks_for_quiz = choices.where(question_id: question_ids).map(&:answer_id)
    picks_for_quiz.sort == quiz.winners.map(&:id).uniq.sort
  end

  def completed_selections_for resource:
    case resource.class.name
    when "Slate"
      events = picks.pending.where( event_id: resource.events.map(&:id) )
      events.size == resource.events.size
    when "Quiz"
      questions = choices.pending.where( question_id: resource.questions.map(&:id) )
      questions.size == resource.questions.size   
    end
  end

  private

  def set_slug
    loop do
      if first_name && last_name
        slug = "#{self.first_name[0]}#{self.last_name}#{SecureRandom.hex(3)}".downcase
        self.slug = slug
        break unless self.class.exists?(slug: slug)
      else
        slug = SecureRandom.hex(9).downcase
        self.slug = slug
        break unless self.class.exists?(slug: slug)
      end
    end
  end

  def set_referral_code
    loop do
      if first_name && last_name
        referral_code = "#{first_name}#{last_name}#{SecureRandom.hex(2)}".downcase
      elsif last_name
        referral_code = "#{last_name}#{SecureRandom.hex(3)}".downcase
      else
        referral_code = "#{SecureRandom.hex(3)}".downcase
      end
      self.referral_code = referral_code
      break unless self.class.exists?(referral_code: referral_code)
    end
  end

  def create_or_update_location
    if saved_change_to_zipcode?
      location = Geocoder.search(zipcode).select { |result| result.country_code == "us" }.first
      Location.find_or_create_by(user_id: id).update_attributes(city: location.try(:city), state: location.try(:state), postcode: zipcode, lat: location.try(:coordinates).try(:first), long: location.try(:coordinates).try(:last), country: location.try(:country), country_code: location.try(:country_code))
    end
  end

  def run_badge_service
    BadgeService::Referral.new(user: self.referred_by).run if saved_change_to_referral_completed_at?
  end

  def run_notification_service
    NotifyReferrerJob.perform_later(referred_by_id, id) if saved_change_to_referral_completed_at?
  end

end
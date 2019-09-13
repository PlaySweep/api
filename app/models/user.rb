class User < ApplicationRecord
  include Redis::Objects

  value :has_recently_won

  rolify

  belongs_to :account, optional: true
  belongs_to :league, foreign_key: :account_id, optional: true
  has_many :sweeps, dependent: :destroy
  has_many :streaks, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :events, through: :picks
  has_many :cards, dependent: :destroy
  has_many :slates, through: :cards
  has_many :entries, dependent: :destroy
  has_many :leaderboard_results
  has_many :leaderboards, through: :leaderboard_results, source: "leaderboard_history", dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :promotions, foreign_key: :used_by, dependent: :destroy
  has_one :location, dependent: :destroy

  after_create :set_slug
  after_update :create_or_update_location

  jsonb_accessor :data,
    referral: [:string, default: "landing_page"]

  jsonb_accessor :shipping,
    line1: [:string, default: nil],
    line2: [:string, default: nil],
    city: [:string, default: nil],
    state: [:string, default: nil],
    postal_code: [:string, default: nil],
    country: [:string, default: "United States"]

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :for_owner, ->(owner_id) { joins(:roles).where('roles.resource_id = ?', owner_id) }
  scope :with_referral, ->(referral) { where("users.data->>'referral' = :referral", referral: "#{referral}")}
  scope :most, ->(association) { left_joins(association.to_sym).group(:id).order("COUNT(#{association.to_s}.id) DESC") }
  
  validates :slug, uniqueness: true

  def self.top_streak limit:
    board = Board.fetch(leaderboard: :allstar_sweep_leaderboard)
    ids = board.top(limit.to_i).map { |user| user[:member] }
    where(id: ids).sort_by(&:rank)
  end

  def current_team
    roles.find_by(resource_type: "Team").try(:resource)
  end

  def eligible_for_drizly?
    reward = account.rewards.find_by(name: "Drizly", category: "Playing")
    rule = DrizlyRule.find_by(name: location.try(:state), category: "Playing", eligible: true)
    reward.active && rule.present?
  end

  def coordinates
    [location.lat, location.long].map(&:to_f)
  end

  def has_recently_won?
    has_recently_won == "1"
  end

  def has_never_played?
    cards.size == 0
  end

  def played_for_first_time?
    cards.size == 1
  end

  def filtered_ids
    roles.map(&:resource_id)
  end

  def streak
    Board.fetch(leaderboard: :allstar_sweep_leaderboard).score_for(id) || 0
  end

  def rank
    Board.fetch(leaderboard: :allstar_sweep_leaderboard).rank_for(id)
  end

  def ordinal_position
    rank.ordinalize.last(2)
  end

  def tied?
    Board.fetch(leaderboard: :allstar_sweep_leaderboard).total_members_in_score_range(streak, streak) > 1.0
  end

  def highest_sweep_streak
    streaks.find_by(type: "SweepStreak").try(:highest) || 0
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

  def completed_selections_for slate
    events = picks.pending.where( event_id: slate.events.map(&:id) )
    events.size == slate.events.size
  end

  private

  def set_slug
    if first_name && last_name
      slug = "#{self.first_name[0]}#{self.last_name}#{SecureRandom.hex(3)}".downcase
      self.update_attributes(slug: slug)
    else
      slug = "#{SecureRandom.hex(3)}#{SecureRandom.hex(3)}#{SecureRandom.hex(3)}".downcase
      self.update_attributes(slug: slug)
    end
  end

  def create_or_update_location
    if saved_change_to_zipcode?
      location = Geocoder.search(zipcode).select { |result| result.country_code == "us" }.first
      Location.find_or_create_by(user_id: id).update_attributes(city: location.try(:city), state: location.try(:state), postcode: zipcode, lat: location.try(:coordinates).try(:first), long: location.try(:coordinates).try(:last), country: location.try(:country), country_code: location.try(:country_code))
    end
  end

end
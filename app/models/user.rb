class User < ApplicationRecord
  rolify

  belongs_to :league, foreign_key: :account_id
  has_many :sweeps, dependent: :destroy
  has_many :streaks, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_many :events, through: :picks
  has_many :cards, dependent: :destroy
  has_many :slates, through: :cards
  has_many :entries, dependent: :destroy
  has_many :orders
  has_one :preference, foreign_key: :user_id

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

  after_create :insert_user_into_leaderboard
  
  def self.top_streak limit:
    board = Board.fetch(leaderboard: :allstar_sweep_leaderboard)
    ids = board.top(limit.to_i).map { |user| user[:member] }
    where(id: ids).sort_by(&:rank)
  end

  def streak
    Board.fetch(leaderboard: :allstar_sweep_leaderboard).score_for(id)
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
    streaks.find_by(type: "Sweep").try(:highest) || 0
  end

  def current_sweep_streak
    streaks.find_by(type: "Sweep").try(:current) || 0
  end

  def current_pick_streak
    # TODO change logic to bring back picks in correct order without using updated at
    # streaks.find_by(type: "Pick").try(:current) || 0
    consecutive_picks = 0
    picks.unfiltered.completed.order(updated_at: :desc).each do |pick|
      return consecutive_picks if pick.loss?
      consecutive_picks += 1 if pick.win?
    end
    consecutive_picks
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

  def won_slate? slate
    event_ids = events.where(slate_id: slate.id).map(&:id)
    picks_for_slate = picks.where(event_id: event_ids).map(&:selection_id)
    picks_for_slate.sort == slate.winners.map(&:id).uniq.sort
  end

  private

  def insert_user_into_leaderboard
    begin
      Board.fetch(leaderboard: :allstar_sweep_leaderboard).rank_member(id.to_s, 0, { name: full_name }.to_json)
    rescue Exception => e
      puts "Error in Redis Leaderboard insert #{e}"
    end
  end

end
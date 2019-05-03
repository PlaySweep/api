class User < ApplicationRecord
  rolify

  has_many :sweeps, dependent: :destroy
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
  scope :count_by_team, ->(team_id) { joins(:roles).where('roles.resource_id = ?', team_id) }
  scope :with_referral, ->(referral) { where("users.data->>'referral' = :referral", referral: "#{referral}")}

  # after_create :assign_default_role

  def self.by_name full_name
    full_name = full_name.split(' ')
    find_by_first_name_and_last_name(full_name[0], full_name[-1])
  end

  def full_name
    first_name && last_name ? "#{first_name} #{last_name}" : ""
  end

  def abbreviated_name
    "#{first_name} #{last_name[0]}."
  end

  def won_slate? slate
    event_ids = events.where(slate_id: slate.id).map(&:id)
    picks_for_slate = picks.where(event_id: event_ids).map(&:selection_id)
    picks_for_slate.sort == slate.winners.map(&:id).uniq.sort
  end

  private  

  def assign_default_role
    self.add_role(:new_user) if self.roles.blank?
  end

end
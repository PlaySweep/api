class Account < ApplicationRecord
  has_many :messages, as: :messageable
  has_many :medias, as: :imageable
  has_many :images, as: :imageable
  has_many :copies, as: :copyable
  has_many :links
  has_many :rewards, as: :rewardable
  has_many :users
  has_many :products

  scope :active, -> { where(active: true) }
  scope :active_referral_rewards, -> { joins(:rewards).where("rewards.category = ?", "Referral") }

  def active_leaderboard?
    active_reward = rewards.active.find_by(category: "Contest")
    active_reward.present?
  end

  def active_leaderboard
    active_reward = rewards.active.find_by(category: "Contest")
    if active_reward.present?
      leaderboard_name = "contest_#{active_reward.name}"
      Board.fetch(leaderboard: leaderboard_name)
    end
  end

  def active_weekly_leaderboard
    active_reward = rewards.active.find_by(category: "Contest")
    if active_reward.present?
      leaderboard_name = "contest_#{current_week}_#{active_reward.name}"
      Board.fetch(leaderboard: leaderboard_name)
    end
  end

  def has_abnormal_weekly_calendar?
    name.eql?("NFL")
  end

  def current_week
    date = DateTime.current.beginning_of_day
    return date.last_week.cweek if date.monday? && has_abnormal_weekly_calendar?
    date.cweek
  end

  def current_day
    date = DateTime.current.beginning_of_day
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

end
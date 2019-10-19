class Account < ApplicationRecord
  has_many :messages, as: :messageable
  has_many :medias, as: :imageable
  has_many :images, as: :imageable
  has_many :copies, as: :copyable
  has_many :targets, class_name: "BroadcastTarget", as: :targetable
  has_many :links
  has_many :rewards, as: :rewardable
  has_many :users

  def active_leaderboard
    active_reward = rewards.active.find_by(category: "Account") # TODO: Do not commit the change to category: "Account" until RTWS is over for MLB
    if active_reward.present?
      leaderboard_name = "week_#{current_week}"
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

end
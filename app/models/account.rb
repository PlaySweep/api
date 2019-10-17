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
    active_reward = rewards.active.find_by(category: "Contest")
    if active_reward.present?
      Board.fetch(leaderboard: active_reward.name.downcase.gsub(" ", "_"))
    end
  end

  def active_daily_leaderboard
    active_reward = rewards.active.find_by(category: "Contest")
    if active_reward.present?
      day = DateTime.current.strftime("%m%d%y")
      Board.fetch(leaderboard: "#{day}_#{active_reward.name.downcase.gsub(" ", "_").to_sym}")
    end
  end

end
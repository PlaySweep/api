class Owner < ApplicationRecord
  resourcify 
  
  belongs_to :account 
  has_many :slates
  has_many :quizzes
  has_many :images, as: :imageable
  has_many :messages, as: :messageable
  has_many :medias, as: :imageable
  has_many :rewards, as: :rewardable

  def active_leaderboard?
    active_reward = rewards.active.find_by(category: "Weekly Points")
    active_reward.present?
  end

  def active_leaderboard
    active_reward = rewards.active.find_by(category: "Weekly Points")
    if active_reward.present?
      leaderboard_name = "#{leaderboard_prefix}_week_#{account.current_week}"
      Board.fetch(leaderboard: leaderboard_name)
    end
  end

  def leaderboard_prefix
    abbreviation.downcase
  end

end
class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true

  scope :active, -> { where(active: true) }
end
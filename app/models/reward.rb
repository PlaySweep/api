class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
end
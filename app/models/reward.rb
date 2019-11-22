class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
  has_many :prizes, as: :prizeable, dependent: :destroy

  scope :active, -> { where(active: true) }
end
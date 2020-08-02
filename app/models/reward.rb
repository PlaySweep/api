class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true
  has_many :prizes, as: :prizeable, dependent: :destroy
  has_many :rules, as: :ruleable, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :for_referral, -> { where(category: "Referral") }
end
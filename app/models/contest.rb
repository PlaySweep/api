class Contest < ApplicationRecord
  belongs_to :account
  has_many :slates
  has_many :images, as: :imageable
  has_many :rewards, as: :rewardable
  has_many :prizes, as: :prizeable, dependent: :destroy

  enum status: [ :inactive, :active ]

  def prize
    return prizes.first if prizes.any?
  end

  def prize?
    prizes.any?
  end
end
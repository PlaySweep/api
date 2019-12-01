class Achievement < ApplicationRecord
  has_many :badges
  has_many :users, through: :badges
  has_many :prizes, as: :prizeable, dependent: :destroy

  jsonb_accessor :data,
    difficulty: [:string, default: nil],
    threshold: [:string, default: nil]

  def prize
    return prizes.first if prizes.any?
  end
  
end
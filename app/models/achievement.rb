class Achievement < ApplicationRecord
  has_many :badges
  has_many :users, through: :badges
  has_many :prizes, as: :prizeable, dependent: :destroy

  store_accessor :data, :difficulty, :threshold, :disclaimer

  def prize
    return prizes.first if prizes.any?
  end
  
end
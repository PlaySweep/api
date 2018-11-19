class Card < ApplicationRecord
  PENDING, WON, LOST = 0, 1, 2
  belongs_to :user
  belongs_to :slate

  enum status: [ :pending, :won, :lost ]

end
class Entry < ApplicationRecord
  # PLAYING, SWEEP = 0, 1
  # belongs_to :user
  # belongs_to :slate, optional: true
  # belongs_to :earned_by, class_name: "User", optional: true

  # enum reason: [ :playing, :sweep ]

  # scope :unused, -> { where(used: false) }
end
class Player < ApplicationRecord
  belongs_to :profile
  belongs_to :participant

  scope :recent, -> { where('created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day) }
end
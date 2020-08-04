class BackgroundJob < ApplicationRecord
  QUEUED, PERFORMED,  = 0, 1
  enum status: [ :queued, :performed ]

  scope :queued, -> { where(status: QUEUED) }
  scope :performed, -> { where(status: PERFORMED) }
end
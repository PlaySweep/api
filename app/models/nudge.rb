class Nudge < ApplicationRecord
  PENDING_REGISTRATION, PENDING_PLAYED = 0, 1
  CURRENT, INACTIVE = 0, 1
  belongs_to :nudger, class_name: "User", foreign_key: :nudger_id
  belongs_to :nudged, class_name: "User", foreign_key: :nudged_id

  enum started: [ :pending_registration, :pending_played ]
  enum status: [ :current, :inactive ]

  before_create :deactivate_nudges
  after_create :send_reminder

  scope :today, -> { where('created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day, DateTime.current.end_of_day) }

  private

  def deactivate_nudges
    nudger.nudges.where(nudged_id: nudged_id).map(&:inactive!)
  end

  def send_reminder
    SendNudgeJob.perform_later(nudger_id, nudged_id)
  end
end
class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true

  scope :unused, -> { where(used: false) }
  scope :for_today, -> { where('schedule_time BETWEEN ? AND ?', DateTime.current.beginning_of_day, DateTime.current.end_of_day) }

  jsonb_accessor :data,
    notification_type: [:string, default: "regular"]

end
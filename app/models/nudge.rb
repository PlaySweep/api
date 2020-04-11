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
    if nudged.confirmed
      quick_replies = FacebookParser::QuickReplyObject.new([
        { content_type: :text,
          title: "Play now",
          payload: "PLAY",
          image_url: nudged.current_team.image
        }
      ]).objects
      FacebookMessaging::Standard.deliver(
        user: nudged,
        message: "Hey #{nudged.first_name}, #{nudger.first_name} #{nudger.last_name} is nudging you to play!",
        notification_type: "SILENT_PUSH",
        quick_replies: quick_replies
      )
    else
      FacebookMessaging::Standard.deliver(
        user: nudged,
        message: "Hey #{nudged.first_name}, #{nudger.first_name} #{nudger.last_name} is nudging you to play!",
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Confirm your account",
        message: "It's only a few more steps, #{nudged.first_name}!",
        url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
        notification_type: "NO_PUSH"
      )
    end
  end
end
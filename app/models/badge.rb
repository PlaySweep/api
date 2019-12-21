class Badge < ApplicationRecord
  INACTIVE, CURRENT = 0, 1
  belongs_to :user
  belongs_to :achievement

  enum status: [ :inactive, :current ]

  before_create :reset_statuses
  after_create :notify_badge

  scope :for_referral_milestones, -> { joins(:achievement).where("achievements.type = ?", "ReferralMilestone") }

  def self.current
    find_by(status: Badge::CURRENT)
  end

  private

  def reset_statuses
    user.badges.map(&:inactive!)
  end

  def notify_badge
    NotifyBadgeJob.perform_later(user_id, achievement.prize.id)
  end

end
class Badge < ApplicationRecord
  INACTIVE, CURRENT = 0, 1
  belongs_to :user
  belongs_to :achievement

  enum status: [ :inactive, :current ]

  before_create :reset_statuses

  scope :for_referral_milestones, -> { joins(:achievement).where("achievements.type = ?", ReferralMilestone::KLASS) }

  def self.current
    find_by(status: Badge::CURRENT)
  end

  private

  def reset_statuses
    user.badges.map(&:inactive!)
  end

end
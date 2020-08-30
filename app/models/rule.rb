class Rule < ApplicationRecord
  belongs_to :ruleable, polymorphic: true

  scope :eligible, -> { where(eligible: true) }

  scope :for_accounts, -> { where(type: "AccountRule") }
  scope :for_contests, -> { where(type: "ContestRule") }
  scope :for_referrals, -> { where(type: "ReferralRule") }
  scope :for_owners, -> { where(type: "OwnerRule") }

  scope :by_elements, -> { where(category: "Elements") }
  scope :by_milestones, -> { where(category: "Milestones") }

  scope :by_playing, -> { where(category: "Playing") }
  scope :by_referring, -> { where(category: "Referral") }
  scope :by_picking, -> { where(category: "Pick") }
  scope :by_sweep, -> { where(category: "Sweep") }
  scope :by_referral_sweep, -> { where(category: "Referral Sweep") }
end
class ReferralEngagementNotificationJob < ApplicationJob
    queue_as :low
  
    def perform referrer_id
      referrer = User.find(referrer_id)
      if referrer.active_referrals.completed.size.include?(User::REFERRAL_THRESHOLD)
        # TODO Handle a new way to message for referral
      end
    end
  end
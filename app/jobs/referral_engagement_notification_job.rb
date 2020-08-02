class ReferralEngagementNotificationJob < ApplicationJob
    queue_as :low
  
    def perform referrer_id
      referrer = User.find(referrer_id)
    end
  end
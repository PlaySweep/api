class ReferralService
  def initialize user:
    @user = user
  end

  def run
    referral_reward
    elements_reward
  end

  def reward
    @user.account.rewards.active.find_by(category: "Referral")
  end

  def reward_active?
    reward.present?
  end

  def referral_reward
    if reward_active?
      if reward.rules.for_referrals.by_milestones.eligible.any?
        puts "Run Badge Service for Milestones..."
        BadgeService::Referral.new(user: @user.referred_by).run
      end
    end
  end

  def elements_reward
    if reward_active?
      if reward.rules.for_referrals.by_elements.eligible.any?
        puts "Run Element Service for Entries..."
        ElementService::Referral.new(user: @user).run
      end
    end
  end
end
class ReferralService
  def initialize user
    @user = user
  end

  def run
    referral_reward
    elements_reward
  end

  def reward_active?
    @reward = @user.account.rewards.active.find_by(category: "Referral")
    @reward.present?
  end

  def referral_reward
    rule = ReferralRuleEvaluator.new(@user).referral_rule
    if reward_active? && rule
      BadgeService::Referral.new(user: self.referred_by).run
      notify_referrer
    end
  end

  def referral_reward
    rule = ReferralRuleEvaluator.new(@user).elements_rule
    if reward_active? && rule
      self.referred_by.elements.create(element_id: 1)
    end
  end

  def notify_referrer
    NotifyReferrerJob.perform_later(referred_by_id, id)
  end

end
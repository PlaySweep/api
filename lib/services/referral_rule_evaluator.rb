class ReferralRuleEvaluator
  def initialize user
    @user = user
  end

  def referral_rule
    Rule.find_by(type: "ReferralRule", category: "Milestones", eligible: true)
  end

  def referral_rule
    Rule.find_by(type: "ReferralRule", category: "Elements", eligible: true)
  end

end
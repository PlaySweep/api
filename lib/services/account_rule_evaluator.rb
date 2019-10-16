class AccountRuleEvaluator
  def initialize user
    @user = user
  end

  def playing_rule
    Rule.find_by(type: "AccountRule", category: "Playing", eligible: true)
  end

  def referral_rule
    Rule.find_by(type: "AccountRule", category: "Referral", eligible: true)
  end

  def pick_rule
    Rule.find_by(type: "AccountRule", category: "Pick", eligible: true)
  end

  def sweep_rule
    Rule.find_by(type: "AccountRule", category: "Sweep", eligible: true)
  end

  def referral_sweep_rule
    Rule.find_by(type: "AccountRule", category: "Referral Sweep", eligible: true)
  end

end
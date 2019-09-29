class ContestRuleEvaluator
  def initialize user
    @user = user
  end

  def playing_rule
    Rule.find_by(type: "ContestRule", category: "Playing", eligible: true)
  end

  def referral_rule
    Rule.find_by(type: "ContestRule", category: "Referral", eligible: true)
  end

  def pick_rule
    Rule.find_by(type: "ContestRule", category: "Pick", eligible: true)
  end

  def sweep_rule
    Rule.find_by(type: "ContestRule", category: "Sweep", eligible: true)
  end

end
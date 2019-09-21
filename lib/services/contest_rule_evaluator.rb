class ContestRuleEvaluator
  def initialize user
    @user = user
  end

  def playing_rule
    Rule.find_by(type: "ContestRule", category: "Playing", eligible: @user.active)
  end

  def referral_rule
    Rule.find_by(type: "ContestRule", category: "Referral", eligible: @user.active)
  end

  def pick_rule
    Rule.find_by(type: "ContestRule", category: "Pick", eligible: @user.active)
  end

  def sweep_rule
    Rule.find_by(type: "ContestRule", category: "Sweep", eligible: @user.active)
  end

end
class DrizlyRuleEvaluator
  def initialize user
    @user = user
  end

  def playing_rule
    Rule.find_by(type: "DrizlyRule", name: @user.location.try(:state), category: "Playing", eligible: true)
  end

  def sweep_rule
    Rule.find_by(type: "DrizlyRule", name: @user.location.try(:state), category: "Sweep", eligible: true)
  end

end
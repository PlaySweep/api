class OwnerRuleEvaluator
    def initialize user
      @user = user
    end
  
    def playing_rule
      Rule.find_by(type: "OwnerRule", category: "Playing", eligible: true)
    end
  
    def referral_rule
      Rule.find_by(type: "OwnerRule", category: "Referral", eligible: true)
    end
  
    def pick_rule
      Rule.find_by(type: "OwnerRule", category: "Pick", eligible: true)
    end
  
    def sweep_rule
      Rule.find_by(type: "OwnerRule", category: "Sweep", eligible: true)
    end
  
    def referral_sweep_rule
      Rule.find_by(type: "OwnerRule", category: "Referral Sweep", eligible: true)
    end
  
  end
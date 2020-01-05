module BadgeService
  class Referral
    def initialize user:
      @user = user
    end

    def run
      case @user.referrals.size
      when 1
        achievement(level: 1)
      when 5
        achievement(level: 2)
      when 15
        achievement(level: 3)
      when 75
        achievement(level: 4)
      end
    end
  
    def achievement level:
      create_badge(level: level)
    end

    def create_badge level:
      milestone = ReferralMilestone.find_by(level: level)
      @user.badges.create(achievement_id: milestone.id)
      return true
    end
  
  end
end
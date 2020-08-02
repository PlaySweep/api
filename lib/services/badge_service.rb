module BadgeService
  class Referral
    def initialize user:
      @user = user
    end

    def has_active_referrals?
      @user && @user.active_referrals.present?
    end

    def run
      if has_active_referrals?
        case @user.active_referrals.completed.size
        when 1
          achievement(level: 1)
        when 10
          achievement(level: 2)
        when 20
          achievement(level: 3)
        when 100
          achievement(level: 4)
        when 500
          achievement(level: 5)
        end
      end
    end
  
    def achievement level:
      puts "Create a Badge for level #{level}..."
      create_badge(level: level)
    end

    def create_badge level:
      milestone = ReferralMilestone.find_by(level: level)
      @user.badges.create(achievement_id: milestone.id)
      return true
    end
  
  end
end
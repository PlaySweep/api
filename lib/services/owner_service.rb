class OwnerService
    def initialize user, slate: nil
      @user, @slate = user, slate
    end
  
    def run type: 
      send("#{type}_reward".to_sym)
    end
  
    def reward_active?
      @reward = @user.current_team.rewards.active.find_by(category: "Weekly Points")
      @reward.present?
    end

    def referral_reward_active?
      if @user.referred_by_id?
        @reward = @user.referred_by.current_team.rewards.active.find_by(category: "Weekly Points")
        @reward.present?
      end
    end
  
    def playing_reward
      playing_rule = OwnerRuleEvaluator.new(@user).playing_rule
      if reward_active? && playing_rule && !@slate.contest_id?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += playing_rule.level)
      end
    end
  
    def referral_reward
      referral_rule = OwnerRuleEvaluator.new(@user).referral_rule
      if referral_reward_active? && referral_rule && @user.referred_by_id?
        member = "week_#{@reward.rewardable.account.current_week}_user_#{@user.referred_by_id}"
        leaderboard_name = "#{@user.referred_by.current_team.leaderboard_prefix}_week_#{@reward.rewardable.account.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += referral_rule.level)
      end
    end
  
    def pick_reward
      pick_rule = OwnerRuleEvaluator.new(@user).pick_rule
      if reward_active? && pick_rule && !@slate.contest_id?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += pick_rule.level)
      end
    end
  
    def sweep_reward
      sweep_rule = OwnerRuleEvaluator.new(@user).sweep_rule
      if reward_active? && sweep_rule && !@slate.contest_id?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end

      if @user.referred_by_id?
        member = "week_#{@slate.current_week}_user_#{@user.referred_by_id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
    end

  end
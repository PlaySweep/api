class AccountService
    def initialize user, slate: nil
      @user, @slate = user, slate
    end
  
    def run type: 
      send("#{type}_reward".to_sym)
    end
  
    def reward_active?
      @reward = @user.account.rewards.active.find_by(category: "Account")
      @reward.present?
    end
  
    def playing_reward
      playing_rule = AccountRuleEvaluator.new(@user).playing_rule
      if reward_active? && playing_rule
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += playing_rule.level)
      end
    end
  
    def referral_reward
      referral_rule = AccountRuleEvaluator.new(@user).referral_rule
      if reward_active? && referral_rule && @user.referred_by_id?
        member = "week_#{@reward.rewardable.current_week}_user_#{@user.referred_by_id}"
        leaderboard_name = "week_#{@reward.rewardable.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += referral_rule.level)
      end
    end
  
    def pick_reward
      pick_rule = AccountRuleEvaluator.new(@user).pick_rule
      if reward_active? && pick_rule
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += pick_rule.level)
      end
    end
  
    def sweep_reward
      user_sweep
      referral_sweep
    end

    private

    def user_sweep
      sweep_rule = AccountRuleEvaluator.new(@user).sweep_rule
      if reward_active? && sweep_rule
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
    end

    def referral_sweep
      sweep_rule = AccountRuleEvaluator.new(@user).referral_sweep_rule
      if reward_active? && sweep_rule && @user.referred_by_id?
        member = "week_#{@slate.current_week}_user_#{@user.referred_by_id}"
        leaderboard_name = "week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
    end

  end
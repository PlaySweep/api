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
        date = @slate.start_time.to_datetime
        member = "week_#{date.cweek}_day_#{date.cwday}_user_#{@user.id}"
        leaderboard_name = "week_#{date.cweek}_day_#{date.cwday}".to_sym
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(member, current_score += playing_rule.level)
      end
    end
  
    def referral_reward
      referral_rule = AccountRuleEvaluator.new(@user).referral_rule
      if reward_active? && referral_rule
        date = DateTime.current.to_datetime
        member = "week_#{date.cweek}_day_#{date.cwday}_user_#{@user.id}"
        leaderboard_name = "week_#{date.cweek}_day_#{date.cwday}".to_sym
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(member, current_score += referral_rule.level)
      end
    end
  
    def pick_reward
      pick_rule = AccountRuleEvaluator.new(@user).pick_rule
      if reward_active? && pick_rule
        date = @slate.start_time.to_datetime
        member = "week_#{date.cweek}_day_#{date.cwday}_user_#{@user.id}"
        leaderboard_name = "week_#{date.cweek}_day_#{date.cwday}".to_sym
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(@user.id) || 0
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
        date = @slate.start_time.to_datetime
        member = "week_#{date.cweek}_day_#{date.cwday}_user_#{@user.id}"
        leaderboard_name = "week_#{date.cweek}_day_#{date.cwday}".to_sym
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
    end

    def referral_sweep
      sweep_rule = AccountRuleEvaluator.new(@user.referred_by).referral_sweep_rule
      if reward_active? && sweep_rule && @user.referred_by_id?
        date = @slate.start_time.to_datetime
        member = "week_#{date.cweek}_day_#{date.cwday}_user_#{@user.referred_by_id}"
        leaderboard_name = "week_#{date.cweek}_day_#{date.cwday}".to_sym
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
    end

  end
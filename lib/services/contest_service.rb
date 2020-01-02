class ContestService
  def initialize user, slate: nil
    @user, @slate = user, slate
  end

  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward_active?
    @reward = @user.account.rewards.active.find_by(category: "Contest")
    @reward.present?
  end

  def playing_reward
    playing_rule = ContestRuleEvaluator.new(@user).playing_rule
    if reward_active? && playing_rule && @slate.contest_id?
      leaderboard = Board.fetch(
        leaderboard: "contest_#{@reward.name}"
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += playing_rule.level)
    end
  end

  def referral_reward
    referral_rule = ContestRuleEvaluator.new(@user).referral_rule
    if reward_active? && referral_rule
      leaderboard = Board.fetch(
        leaderboard: "contest_#{@reward.name}"
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += referral_rule.level)
    end
  end

  def pick_reward
    pick_rule = ContestRuleEvaluator.new(@user).pick_rule
    if reward_active? && pick_rule && @slate.contest_id?
      leaderboard = Board.fetch(
        leaderboard: "contest_#{@reward.name}"
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += pick_rule.level)
    end
  end

  def sweep_reward
    sweep_rule = ContestRuleEvaluator.new(@user).sweep_rule
    if reward_active? && sweep_rule && @slate.contest_id?
      leaderboard = Board.fetch(
        leaderboard: "contest_#{@reward.name}"
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += sweep_rule.level)
      
      if @user.referred_by_id?
        current_referrer_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_referrer_score += sweep_rule.level)
      end
      
    end
  end

end
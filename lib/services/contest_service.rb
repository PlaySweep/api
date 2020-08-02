class ContestService
  def initialize user:, contest:
    @user = user
    @contest = contest
  end

  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward
    @contest && @contest.rewards.active.find_by(category: "Leaderboard")
  end

  def reward_active?
    reward.present?
  end

  def playing_reward
    if reward_active?
      if reward.rules.for_contests.by_playing.eligible.any?
        leaderboard = Board.fetch(
          leaderboard: "contest_#{@reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += playing_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def referral_reward
    if reward_active?
      if reward.rules.for_contests.by_referring.eligible.any?
        leaderboard = Board.fetch(
          leaderboard: "contest_#{@reward.name}"
        )
        current_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_score += referral_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def pick_reward
    if reward_active?
      if reward.rules.for_contests.by_picking.eligible.any?
        leaderboard = Board.fetch(
          leaderboard: "contest_#{@reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += pick_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def sweep_reward
    if reward_active?
      if reward.rules.for_contests.by_sweep.eligible.any?
        leaderboard = Board.fetch(
          leaderboard: "contest_#{@reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += sweep_rule.level, { username: @user.abbreviated_name }.to_json)
      end  
      if reward.rules.for_contests.by_referral_sweep.eligible.any? && @user.referred_by_id?
        current_referrer_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_referrer_score += sweep_rule.level, { username: @user.referred_by.abbreviated_name }.to_json)
      end
    end
  end

end
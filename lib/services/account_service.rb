class AccountService
  def initialize user:
    @user = user
  end

  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward
    @user.account.rewards.active.find_by(category: "Contest")
  end

  def reward_active?
    reward.present?
  end

  def playing_reward
    if reward_active?
      if reward.rules.for_accounts.by_playing.eligible.any?
        playing_rule = reward.rules.for_accounts.by_playing.eligible.first
        leaderboard = Board.fetch(
          leaderboard: "contest_#{reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += playing_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def referral_reward
    if reward_active?
      if reward.rules.for_accounts.by_referring.eligible.any?
        referral_rule = reward.rules.for_accounts.by_referring.eligible.first
        leaderboard = Board.fetch(
          leaderboard: "contest_#{reward.name}"
        )
        current_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_score += referral_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def pick_reward
    if reward_active?
      if reward.rules.for_accounts.by_picking.eligible.any?
        pick_rule = reward.rules.for_accounts.by_picking.eligible.first
        leaderboard = Board.fetch(
          leaderboard: "contest_#{reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += pick_rule.level, { username: @user.abbreviated_name }.to_json)
      end
    end
  end

  def sweep_reward
    if reward_active?
      if reward.rules.for_accounts.by_sweep.eligible.any?
        sweep_rule = reward.rules.for_accounts.by_sweep.eligible.first
        leaderboard = Board.fetch(
          leaderboard: "contest_#{reward.name}"
        )
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += sweep_rule.level, { username: @user.abbreviated_name }.to_json)
      end  
      if reward.rules.for_accounts.by_referral_sweep.eligible.any? && @user.referred_by_id?
        sweep_rule = reward.rules.for_accounts.by_referral_sweep.eligible.first
        leaderboard = Board.fetch(
          leaderboard: "contest_#{reward.name}"
        )
        current_referrer_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_referrer_score += sweep_rule.level, { username: @user.referred_by.abbreviated_name }.to_json)
      end
    end
  end

end
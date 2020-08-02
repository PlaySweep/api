class OwnerService
  def initialize user:, slate: nil
    @user = user
    @slate = slate
  end
  
  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward
    @user.current_team.rewards.active.find_by(category: "Leaderboard")
  end

  def reward_active?
    reward.present?
  end
  
  def playing_reward
    if reward_active?
      if reward.rules.for_owners.by_playing.eligible.any?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += playing_rule.level)
      end
    end
  end
  
  def referral_reward
    if reward_active?
      if reward.rules.for_owners.by_referring.eligible.any?
        member = "week_#{@reward.rewardable.account.current_week}_user_#{@user.referred_by_id}"
        leaderboard_name = "#{@user.referred_by.current_team.leaderboard_prefix}_week_#{@reward.rewardable.account.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += referral_rule.level)
      end
    end
  end
  
  def pick_reward
    if reward_active?
      if reward.rules.for_owners.by_picking.eligible.any?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += pick_rule.level)
      end
    end
  end
  
  def sweep_reward
    if reward_active?
      if reward.rules.for_owners.by_sweep.eligible.any?
        member = "week_#{@slate.current_week}_user_#{@user.id}"
        leaderboard_name = "#{@user.current_team.leaderboard_prefix}_week_#{@slate.current_week}"
        leaderboard = Board.fetch(
          leaderboard: leaderboard_name
        )
        current_score = leaderboard.score_for(member) || 0
        leaderboard.rank_member(member, current_score += sweep_rule.level)
      end
      if reward.rules.for_owners.by_referral_sweep.eligible.any? && @user.referred_by_id?
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
end
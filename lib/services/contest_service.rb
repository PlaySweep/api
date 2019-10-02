class ContestService
  def initialize user, slate: nil
    @user, @slate = user, slate
  end

  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward_active?
    @reward = @user.account.rewards.find_by(category: "Contest", active: true)
    @reward.present?
  end

  def playing_reward
    playing_rule = ContestRuleEvaluator.new(@user).playing_rule
    if reward_active? && @slate.global? && playing_rule
      day = @slate.start_time.strftime("%m%d%y")
      member = "#{day}_#{@user.id}"
      daily_leaderboard = Board.fetch(
        leaderboard: "#{@reward.name.downcase.gsub(" ", "_")}_#{day}".to_sym
      )
      leaderboard = Board.fetch(
        leaderboard: @reward.name.downcase.gsub(" ", "_").to_sym
      )
      current_daily_score = daily_leaderboard.score_for(member) || 0
      daily_leaderboard.rank_member(member, current_daily_score += playing_rule.level)

      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += playing_rule.level)
    end
  end

  def referral_reward
    referral_rule = ContestRuleEvaluator.new(@user).referral_rule
    if reward_active? && referral_rule
      day = DateTime.current.strftime("%m%d%y")
      member = "#{day}_#{@user.id}"
      daily_leaderboard = Board.fetch(
        leaderboard: "#{@reward.name.downcase.gsub(" ", "_")}_#{day}".to_sym
      )
      leaderboard = Board.fetch(
        leaderboard: @reward.name.downcase.gsub(" ", "_").to_sym
      )
      current_daily_score = daily_leaderboard.score_for(member) || 0
      daily_leaderboard.rank_member(member, current_daily_score += referral_rule.level)

      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += referral_rule.level)
    end
  end

  def pick_reward
    pick_rule = ContestRuleEvaluator.new(@user).pick_rule
    if reward_active? && @slate.global? && pick_rule
      day = @slate.start_time.strftime("%m%d%y")
      member = "#{day}_#{@user.id}"
      daily_leaderboard = Board.fetch(
        leaderboard: "#{@reward.name.downcase.gsub(" ", "_")}_#{day}".to_sym
      )
      leaderboard = Board.fetch(
        leaderboard: @reward.name.downcase.gsub(" ", "_").to_sym
      )
      current_daily_score = daily_leaderboard.score_for(member) || 0
      daily_leaderboard.rank_member(member, current_daily_score += pick_rule.level)

      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += pick_rule.level)
    end
  end

  def sweep_reward
    sweep_rule = ContestRuleEvaluator.new(@user).sweep_rule
    if reward_active? && @slate.global? && sweep_rule
      day = @slate.start_time.strftime("%m%d%y")
      daily_leaderboard = Board.fetch(
        leaderboard: "#{@reward.name.downcase.gsub(" ", "_")}_#{day}".to_sym
      )
      leaderboard = Board.fetch(
        leaderboard: @reward.name.downcase.gsub(" ", "_").to_sym
      )
      # Add points to user for sweep
      member = "#{day}_#{@user.id}"
      current_daily_score = daily_leaderboard.score_for(member) || 0
      daily_leaderboard.rank_member(member, current_daily_score += sweep_rule.level)

      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += sweep_rule.level)
    end
  end


end
class ContestService
  def initialize user, slate:
    @user, @slate = user, slate
  end

  def run type: 
    send("#{type}_reward".to_sym)
  end

  def reward_active? category:
    @reward = @user.account.rewards.find_by(name: "Contest", category: category, active: true)
    @reward.present?
  end

  def playing_reward
    if reward_active?(category: "Playing") && @slate.global?
      leaderboard = Board.fetch(
        leaderboard: @reward.description.downcase.gsub(" ", "_").to_sym
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += 1)
    end
  end

  def referral_reward
    if reward_active?(category: "Referral")
      leaderboard = Board.fetch(
        leaderboard: @reward.description.downcase.gsub(" ", "_").to_sym
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += 3)
    end
  end

  def pick_reward
    if reward_active?(category: "Pick") && @slate.global?
      leaderboard = Board.fetch(
        leaderboard: @reward.description.downcase.gsub(" ", "_").to_sym
      )
      current_score = leaderboard.score_for(@user.id) || 0
      leaderboard.rank_member(@user.id, current_score += 1)
    end
  end

  def sweep_reward
    if reward_active?(category: "Sweep") && @slate.global?
      leaderboard = Board.fetch(
        leaderboard: @reward.description.downcase.gsub(" ", "_").to_sym
      )
      if @user.referred_by_id?
        # Add points to referred by
        current_referred_by_score = leaderboard.score_for(@user.referred_by_id) || 0
        leaderboard.rank_member(@user.referred_by_id, current_referred_by_score += 3)
        # Add points to user for sweep
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += 3)
      else
        # Add points to user for sweep
        current_score = leaderboard.score_for(@user.id) || 0
        leaderboard.rank_member(@user.id, current_score += 3)
      end
    end
  end


end
class DrizlyService
  def initialize user, resource
    @user, @resource = user, resource
  end

  def run type: 
    case type
    when :playing
      for_playing
    when :sweep
      for_sweep
    end
  end

  def playing_reward_active?
    @user.account.rewards.active.find_by(name: "Drizly", category: "Playing").present?
  end

  def sweep_reward_active?
    @user.account.rewards.active.find_by(name: "Drizly", category: "Sweep").present?
  end

  def for_playing
    playing_rule = DrizlyRuleEvaluator.new(@user).playing_rule
    if @resource.class.name == "Slate"
      if @user.played_for_first_time? && playing_rule && playing_reward_active?
        if promotion = DrizlyPromotion.find_by(category: "Playing", used: false, level: playing_rule.level)
          promotion.update_attributes(used_by: @user.id, slate_id: @resource.id, used: true)
          DrizlyPlayMailer.notify(@user, promotion).deliver_later
        end unless @resource.contest_id?
      else
        SendSlateNotificationJob.perform_later(@user.id, @resource.id)
      end
    end
  end

  def for_sweep
    sweep_rule = DrizlyRuleEvaluator.new(@user).sweep_rule
    if sweep_rule && sweep_reward_active? && @user.won_for_first_time?
      if promotion = DrizlyPromotion.find_by(category: "Sweep", used: false, level: sweep_rule.level)
        promotion.update_attributes(used_by: @user.id, slate_id: @resource.id, used: true)
        SendWinningSlateMessageWithDrizlyJob.perform_later(@user.id, @resource.id) if @resource.class.name == "Slate"
        SendWinningTriviaMessageJob.set(wait_until: 30.seconds.from_now).perform_later(@user.id, @resource.id) if @resource.class.name == "Quiz"
      end unless @resource.contest_id?
    else
      SendWinningSlateMessageJob.perform_later(@user.id, @resource.id) if @resource.class.name == "Slate"
      SendWinningTriviaMessageJob.set(wait_until: 30.seconds.from_now).perform_later(@user.id, @resource.id) if @resource.class.name == "Quiz"
    end
  end
end
class DrizlyService
  def initialize user, slate
    @user, @slate = user, slate
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
    @user.account.rewards.find_by(name: "Drizly", category: "Playing", active: true).present?
  end

  def sweep_reward_active?
    @user.account.rewards.find_by(name: "Drizly", category: "Sweep", active: true).present?
  end

  def for_playing
    playing_rule = DrizlyRuleEvaluator.new(@user).playing_rule
    if @user.played_for_first_time? && playing_rule && playing_reward_active?
      if promotion = DrizlyPromotion.find_by(category: "Playing", used: false, level: playing_rule.level)
        promotion.update_attributes(used_by: @user.id, slate_id: @slate.id, used: true)
        DrizlyPlayMailer.notify(@user, promotion).deliver_later
        SendSlateNotificationWithDrizlyJob.perform_later(@user.id, @slate.id)
      end
    else
      SendSlateNotificationJob.perform_later(@user.id, @slate.id)
    end
  end

  def for_sweep
    sweep_rule = DrizlyRuleEvaluator.new(@user).sweep_rule
    if sweep_rule && sweep_reward_active?
      if promotion = DrizlyPromotion.find_by(category: "Sweep", used: false, level: sweep_rule.level)
        promotion.update_attributes(used_by: @user.id, slate_id: @slate.id, used: true)
        SendWinningSlateMessageWithDrizlyJob.perform_later(@user.id, @slate.id)
      end
    else
      SendWinningSlateMessageJob.perform_later(@user.id, @slate.id)
    end
  end
end
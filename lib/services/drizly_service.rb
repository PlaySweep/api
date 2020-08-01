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

  def reward_active?
    @user.account.rewards.active.find_by(category: "Drizly").present?
  end

  def for_playing
    playing_rule = DrizlyRuleEvaluator.new(@user).playing_rule
    if @resource.class.name == "Slate"
      if @user.played_for_first_time? && playing_rule && reward_active?
        if promotion = DrizlyPromotion.find_by(category: "Playing", used: false, level: playing_rule.level)
          promotion.update_attributes(used_by: @user.id, slate_id: @resource.id, used: true)
          DrizlyPlayMailer.notify(@user, promotion).deliver_later
        end
      end
    end
  end

  def for_sweep
    sweep_rule = DrizlyRuleEvaluator.new(@user).sweep_rule
    if sweep_rule && reward_active? && @user.won_for_first_time?
      if promotion = DrizlyPromotion.find_by(category: "Sweep", used: false, level: sweep_rule.level)
        promotion.update_attributes(used_by: @user.id, slate_id: @resource.id, used: true)
      end
    end
  end
end
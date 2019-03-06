class UserAnalytics
  def initialize user
    @user = user
    $tracker.people.set(@user.id, {
      '$first_name'       => @user.first_name,
      '$last_name'        => @user.last_name,
      '$full_name'        => @user.full_name,
      '$last_seen'       => Time.now
    }, ip = 0, {'$ignore_time' => 'true'})
  end

  def new_user
    $tracker.track(@user.id, 'New User', { account: @user.preference.team.account.name, team: @user.preference.team.name })
  end

  def account_confirmed
    $tracker.track(@user.id, 'Account Confirmed', { account: @user.preference.team.account.name, team: @user.preference.team.name })
  end

end

class CardAnalytics
  def initialize card
    @card = card
    $tracker.people.set(@card.user.id, {
      '$first_name'       => @card.user.first_name,
      '$last_name'        => @card.user.last_name,
      '$full_name'        => @card.user.full_name,
      '$last_seen'       => Time.now
    }, ip = 0, {'$ignore_time' => 'true'})
  end

  def card_started
    $tracker.track(@card.user_id, "Card Started", { account: @card.user.preference.team.account.name, team: @card.slate.team.name, prize: @card.slate.try(:prizing_category) })
  end

  def card_completed
    $tracker.track(@card.user_id, "Card Completed", { account: @card.user.preference.team.account.name, team: @card.slate.team.name, prize: @card.slate.try(:prizing_category) })
  end
end
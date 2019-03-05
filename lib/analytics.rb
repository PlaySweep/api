class Analytics
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
    $tracker.track(@user.id, 'New User')
  end

  def card_played
    $tracker.track(@user.id, "Card Played")
  end

  def account_confirmed
    $tracker.track(@user.id, 'Account Confirmed')
  end

end
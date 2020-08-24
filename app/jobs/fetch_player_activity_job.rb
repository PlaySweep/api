class FetchPlayerActivityJob < ApplicationJob
  queue_as :low

  def perform
    fetch_player_activity
  end

  def fetch_player_activity
    unique_ids_two_weeks_ago = Card.for_slates.between_days('slates', 14, 8).select(:user_id).distinct.pluck(:user_id)
    unique_ids_one_week_ago = Card.for_slates.between_days('slates', 7, 1).select(:user_id).distinct.pluck(:user_id)
    returned_user_ids = unique_ids_two_weeks_ago.select { |id| unique_ids_one_week_ago.include?(id) }
    left_user_ids = unique_ids_two_weeks_ago.reject { |id| unique_ids_one_week_ago.include?(id) }
    returned_users = User.where(id: returned_user_ids).sample(25)
    left_users = User.where(id: left_user_ids).sample(25)
    message_count = Notification.where('notifications.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day - 1).size
    new_users = User.where('users.created_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day - 1).sample(25)
    confirmed_can_users = Hash.new(0)
    can_users = Hash.new(0)
    User.confirmed.where(source: "mlb_scan_lp").each do |user|
      role = user.roles.first
      role ? confirmed_can_users[user.roles.first.name] += 1 : confirmed_can_users['global'] += 1
    end
    User.where(confirmed: false).where(source: "mlb_scan_lp").each do |user|
      role = user.roles.first
      role ? can_users[user.roles.first.name] += 1 : can_users['global'] += 1
    end
    registered_count = confirmed_can_users.size
    unregistered_count = can_users.size
    phone_number_count = PhoneNumber.all.size
    WeeklyUserActivityMailer.stats_email(
      new_users: new_users, 
      returned_users: returned_users, 
      left_users: left_users,
      message_count: message_count,
      can_users: can_users,
      confirmed_can_users: confirmed_can_users,
      registered_count: registered_count,
      unregistered_count: unregistered_count,
      phone_number_count: phone_number_count
    ).deliver_now
  end

end
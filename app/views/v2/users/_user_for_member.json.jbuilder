json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.full_name user.full_name
json.abbreviated_name user.abbreviated_name
json.handle user.handle
json.email user.email
json.dob user.dob
json.zipcode user.zipcode
json.confirmed user.confirmed
json.locked user.locked
json.slug user.slug
json.referral_code user.referral_code
json.referral_count user.active_referrals.completed.size
json.has_never_played user.has_never_played?
json.played_for_first_time user.played_for_first_time?
json.location user.location
json.current_team user.current_team, partial: 'v2/teams/team', as: :team
json.current_team_is_default user.current_team_is_default?
json.current_team_leaderboard user.current_team.active_leaderboard.present?
json.current_account_leaderboard user.account.active_leaderboard.present?
json.account do
  json.id user.account.id
  json.name user.account.name
  json.image user.account.image
  json.friendly_name user.account.friendly_name
  json.app_name user.account.app_name
  json.tenant user.account.tenant
  json.active user.account.active
  json.images user.account.images.each do |image|
    json.id image.id
    json.description image.description
    json.category image.category
    json.url image.url
  end
  json.display_week user.account.display_week
end
json.copies user.account.copies.active.each do |copy|
  json.id copy.id
  json.category copy.category
  json.message copy.message
end
json.images user.account.images.each do |image|
  json.id image.id
  json.category image.category
  json.url image.url
end
json.links user.account.links.each do |link|
  json.id link.id
  json.category link.category
  json.url link.url
end
json.addresses user.addresses
json.primary_address user.primary_address
json.phone_number user.phone_number
json.promotions user.promotions
json.stats do
  json.current_pick_streak user.current_pick_streak
end
json.latest_stats user.latest_stats
json.latest_contest_activity user.latest_contest_activity
json.recent_orders user.orders.recent, partial: 'v2/orders/order', as: :order
json.current_badge user.badges.active.for_referral_milestones.current, partial: "v2/badges/badge", as: :badge
json.current_badge_exist user.badges.active.for_referral_milestones.current.present?
json.badges user.badges, partial: "v2/badges/badge", as: :badge
json.referrals user.active_referrals.recent, partial: "v2/users/referral", as: :referral
json.settings do
  json.email_reminder user.email_reminder
  json.email_recap user.email_recap
  json.sms_reminder user.sms_reminder
end

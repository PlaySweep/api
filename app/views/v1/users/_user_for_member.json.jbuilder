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
json.has_recently_won user.has_recently_won?
json.has_never_played user.has_never_played?
json.played_for_first_time user.played_for_first_time?
json.eligible_for_drizly user.eligible_for_drizly?
json.location user.location
json.current_team user.current_team, partial: 'v1/teams/team', as: :team
json.current_team_is_default user.current_team_is_default?
json.leaderboard do
  if user.account.active_leaderboard
    json.name user.account.active_leaderboard.leaderboard_name.split("_").map(&:capitalize).join(" ").to_s
    json.overall do
      json.top_scorers user.account.active_leaderboard.top(3)
      json.around_me user.around_me
      json.rank user.rank
      json.score user.score
      json.ordinal_position user.ordinal_position
      json.tied user.tied?
    end
  else
    {}
  end
end
json.account do
  json.id user.account.id
  json.name user.account.name
  json.image user.account.image
  json.friendly_name user.account.friendly_name
  json.app_name user.account.app_name
  json.tenant user.account.tenant
  json.images user.account.images.each do |image|
    json.id image.id
    json.description image.description
    json.category image.category
    json.url image.url
  end
end
json.copies user.account.copies.each do |copy|
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
json.shipping user.shipping
json.promotions user.promotions
json.stats do
  json.current_pick_streak user.current_pick_streak
end
json.latest_stats user.latest_stats
json.recent_orders user.orders.recent, partial: 'v1/orders/order', as: :order
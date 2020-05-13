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
json.phone_number_exists user.phone_number?
json.confirmed user.confirmed
json.locked user.locked
json.slug user.slug
json.referral_code user.referral_code
json.referral_count user.referrals.completed.size
json.has_never_played user.has_never_played?
json.played_for_first_time user.played_for_first_time?
json.eligible_for_drizly user.eligible_for_drizly?
json.location user.location
json.current_team user.current_team, partial: 'v1/teams/team', as: :team
json.current_team_is_default user.current_team_is_default?
json.current_team_leaderboard user.current_team.active_leaderboard.present?
json.current_account_leaderboard user.account.active_leaderboard.present?
json.leaderboard do
  json.account do
    json.name user.account.rewards.active.find_by(category: "Contest").description
    json.top_scorers user.account.active_leaderboard.top(3, { with_member_data: true })
    json.rank user.account.active_leaderboard.rank_for(user.id).to_i || 0
    json.score user.account.active_leaderboard.score_for(user.id).to_i || 0
    json.ordinal_position user.account.active_leaderboard.rank_for(user.id).to_i.ordinalize.last(2)
    json.tied user.account.active_leaderboard.total_members_in_score_range(user.account.active_leaderboard.score_for(user.id).to_i, user.account.active_leaderboard.score_for(user.id).to_i) > 1.0
  end if user.account.active_leaderboard?
  json.owner do
    json.name user.current_team.rewards.active.find_by(category: "Weekly Points").description
    json.top_scorers user.current_team.active_leaderboard.top(3, { with_member_data: true })
    json.rank user.current_team.active_leaderboard.rank_for("week_#{user.account.current_week}_user_#{user.id}").to_i || 0
    json.score user.current_team.active_leaderboard.score_for("week_#{user.account.current_week}_user_#{user.id}").to_i || 0
    json.ordinal_position user.current_team.active_leaderboard.rank_for("week_#{user.account.current_week}_user_#{user.id}").to_i.ordinalize.last(2)
    json.tied user.current_team.active_leaderboard.total_members_in_score_range(user.current_team.active_leaderboard.score_for("week_#{user.account.current_week}_user_#{user.id}").to_i, user.current_team.active_leaderboard.score_for("week_#{user.account.current_week}_user_#{user.id}").to_i) > 1.0
  end if user.current_team.active_leaderboard?
end
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
json.addresses user.addresses
json.phone_number user.phone_number
json.promotions user.promotions
json.stats do
  json.current_pick_streak user.current_pick_streak
end
json.latest_stats user.latest_stats
json.latest_contest_activity user.latest_contest_activity
json.recent_orders user.orders.recent, partial: 'v1/orders/order', as: :order
json.current_badge user.badges.for_referral_milestones.current, partial: "v1/badges/badge", as: :badge
json.current_badge_exist user.badges.for_referral_milestones.current.present?
json.badges user.badges, partial: "v1/badges/badge", as: :badge
json.referrals user.referrals.recent, partial: "v1/users/referral", as: :referral
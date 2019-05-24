json.id slate.id
json.name slate.name
json.description slate.description
json.progress slate.progress(current_user.id)
json.event_size slate.events.size
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.global slate.global
json.result slate.result
json.score slate.score
json.winner slate.winner, partial: 'v1/budweiser/users/user_for_member', as: :user
json.previous_user_ids slate.previous_user_ids
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.slate_id prize.slate_id
  json.sku_id prize.sku_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.image prize.product.image
  json.category prize.product.category
end
if slate.global
  json.team do
    json.id slate.team_id
    json.image Team.find(slate.team_id).image
    json.local_image Team.find(slate.team_id).try(:local_image)
    json.field slate.field
    json.pitcher slate.try(:pitcher)
    json.standing slate.try(:standing)
  end
  json.opponent do
    json.id slate.try(:opponent).try(:id)
    json.image slate.try(:opponent).try(:image)
    json.standing slate.try(:opponent_standing)
  end if slate.opponent
else
  json.team do
    json.id slate.team.id
    json.image slate.team.image
    json.local_image slate.team.try(:local_image)
    json.field slate.field
    json.standing slate.try(:standing)
  end
end

json.opponent do
  json.id slate.try(:opponent).try(:id)
  json.image slate.try(:opponent).try(:image)
  json.pitcher slate.try(:opponent_pitcher)
  json.standing slate.try(:opponent_standing)
end if slate.opponent
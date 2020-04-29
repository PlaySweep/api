json.id slate.id
json.name slate.name
json.description slate.description
json.events slate.events.ordered, partial: 'v2/events/event', as: :event
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.is_contest slate.contest_id?
json.contest_id slate.contest_id
json.winner slate.winner, partial: 'v2/users/user_for_member', as: :user
json.has_winner slate.has_winner?
json.previous_user_ids slate.previous_user_ids
json.total_sweeps slate.cards.win.size
json.total_entries slate.cards.size
json.event_size slate.events.size
json.result slate.result
json.score slate.score
json.number_of_correct_answers slate.number_of_correct_answers_for(current_user.id)
json.played slate.played?(current_user.id)
json.user_sweeped slate.user_sweeped?(current_user.id)
json.prize do
  json.id slate.prize.id
  json.product do 
    json.id slate.prize.product.id
    json.name slate.prize.product.name
    json.category slate.prize.product.category
  end
  json.date slate.prize.date
end unless slate.contest_id?
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.sku_id prize.sku_id
  json.product_id prize.product_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.image prize.product.image
  json.category prize.product.category
  json.date prize.date
end
json.participants slate.participants.each do |participant|
  json.id participant.id
  json.field participant.field
  json.team participant.team, partial: 'v2/teams/team', as: :team
  json.player participant.player, partial: 'v2/players/player', as: :player
end
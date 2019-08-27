json.id slate.id
json.name slate.name
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.global slate.global
json.result slate.result
json.score slate.score
json.total_sweeps slate.cards.win.size
json.total_entries slate.cards.size
json.event_size slate.events.size
json.number_of_correct_answers slate.number_of_correct_answers_for(current_user.id)
json.played slate.played?(current_user.id)
json.winner slate.winner, partial: 'v1/users/user_for_member', as: :user
json.has_winner slate.has_winner?
json.previous_user_ids slate.previous_user_ids
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.slate_id prize.slate_id
  json.sku_id prize.sku_id
  json.product_id prize.product_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.image prize.product.image
  json.category prize.product.category
  json.date prize.date
end
json.team do
  json.id slate.team.id
  json.image slate.team.image
  json.abbreviation slate.team.abbreviation
  json.initials slate.team.initials
  json.local_image slate.team.try(:local_image)
  json.entry_image slate.team.try(:entry_image)
  json.field slate.field
  json.pitcher slate.try(:pitcher)
  json.standing slate.try(:standing)
end
json.opponent do
  json.id slate.try(:opponent).try(:id)
  json.image slate.try(:opponent).try(:image)
  json.abbreviation slate.try(:opponent).try(:abbreviation)
  json.initials slate.try(:opponent).try(:initials)
  json.pitcher slate.try(:opponent_pitcher)
  json.standing slate.try(:opponent_standing)
end if slate.opponent
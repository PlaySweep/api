json.id slate.id
json.name slate.name
json.description slate.description
json.progress slate.progress(current_user.id)
json.events slate.events.ordered, partial: 'v1/turner/events/event', as: :event
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.slate_id prize.slate_id
  json.sku_id prize.sku_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.image prize.product.image
end
json.team do
  json.id slate.team.id
  json.image slate.team.image
  json.local_image slate.team.try(:local_image)
  json.field slate.field
  json.pitcher slate.try(:pitcher)
end
json.opponent do
  json.id slate.try(:opponent).try(:id)
  json.image slate.try(:opponent).try(:image)
  json.pitcher slate.try(:opponent_pitcher)
end if slate.opponent
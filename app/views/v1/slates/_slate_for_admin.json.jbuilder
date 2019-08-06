json.id slate.id
json.name slate.name
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.events slate.events.ordered, partial: 'admin/events/event_for_admin', as: :event
json.local slate.local
json.global slate.global
json.winner slate.winner, partial: 'v1/users/user_for_member', as: :user
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.slate_id prize.slate_id
  json.sku_id prize.sku_id
  json.product_id prize.product_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
  json.date prize.date
end
json.data slate.data
json.start_time slate.start_time
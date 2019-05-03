json.id slate.id
json.name slate.name
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.events slate.events.ordered, partial: 'admin/events/event_for_admin', as: :event
json.local slate.local
json.result slate.result
json.score slate.score
json.prizes slate.prizes.each do |prize|
  json.id prize.id
  json.slate_id prize.slate_id
  json.sku_id prize.sku_id
  json.name prize.product.name
  json.description prize.product.description
  json.quantity prize.quantity
end
json.data slate.data
json.entries slate.entries, partial: 'admin/entries/entry_for_admin', as: :entry
json.winner slate.try(:winner).try(:full_name)
json.start_time slate.start_time
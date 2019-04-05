json.cache! ["event-{event.id}", event], expires_in: 5.minutes do
  json.id event.id
  json.description event.description
  json.order event.order
  json.status event.status
  json.winners event.winners, partial: 'v1/budweiser/selections/selection', as: :selection
  json.selections event.selections.ordered, partial: 'v1/budweiser/selections/selection', as: :selection
end
json.id slate.id
json.name slate.name
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.events slate.events.ordered, partial: 'v1/budweiser/events/event', as: :event
json.local slate.local
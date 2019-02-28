json.id slate.id
json.name slate.name
json.description slate.description
# json.progress slate.progress(current_user.id)
json.events slate.events.ordered, partial: 'v1/budweiser/events/event', as: :event
json.status slate.status
json.start_time slate.start_time
json.local slate.local
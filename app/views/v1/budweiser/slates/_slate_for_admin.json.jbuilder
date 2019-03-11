json.id slate.id
json.name slate.name
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.events slate.events.ordered, partial: 'admin/events/event_for_admin', as: :event
json.local slate.local
json.data slate.data
json.entries slate.entries, partial: 'admin/entries/entry_for_admin', as: :entry
json.winner slate.try(:winner).try(:full_name)
json.start_time slate.start_time
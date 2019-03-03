json.id slate.id
json.name slate.name
json.description slate.description
# json.progress slate.progress(current_user.id)
json.event_size slate.events.size
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.team do
  json.id slate.team.id
  json.image slate.team.image
  json.local_image slate.team.local_image
  json.field slate.field
end
json.opponent do
  json.id slate.opponent.id
  json.image slate.opponent.image
end if slate.opponent
json.cache! ["slate-{slate.id}", slate], expires_in: 5.minutes do
  json.id slate.id
  json.name slate.name
  json.description slate.description
  json.progress slate.progress(current_user.id)
  json.event_size slate.events.size
  json.status slate.status
  json.start_time slate.start_time
  json.local slate.local
  json.prizing_category slate.prizing_category
  json.team do
    json.id slate.team.id
    json.image slate.team.image
    json.local_image slate.team.try(:local_image)
    json.field slate.field
  end
  json.opponent do
    json.id slate.try(:opponent).try(:id)
    json.image slate.try(:opponent).try(:image)
  end if slate.opponent
end
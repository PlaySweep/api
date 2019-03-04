json.id slate.id
json.name slate.name
json.description slate.description
json.progress slate.progress(current_user.id)
json.events slate.events.ordered, partial: 'v1/budweiser/events/event', as: :event
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.prizing_category slate.prizing_category
json.team do
  json.id slate.team.id
  json.image slate.team.image
  json.local_image slate.team.try(:local_image)
  json.field slate.field
  json.pitcher slate.try(:pitcher)
  json.era slate.try(:era)
end
json.opponent do
  json.id slate.try(:opponent).try(:id)
  json.image slate.try(:opponent).try(:image)
  json.pitcher slate.try(:opponent_pitcher)
  json.era slate.try(:opponent_era)
end if slate.opponent
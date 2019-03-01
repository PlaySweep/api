json.id slate.id
json.name slate.name
json.description slate.description
# json.progress slate.progress(current_user.id)
json.events slate.events.ordered, partial: 'v1/budweiser/events/event', as: :event
json.status slate.status
json.start_time slate.start_time
json.local slate.local
json.team do
  json.id slate.team.id
  json.image slate.team.image
  json.field slate.field
  json.pitcher slate.pitcher
  json.era slate.era
end
json.opponent do
  json.id slate.opponent.id
  json.image slate.opponent.image
  json.pitcher slate.opponent_pitcher
  json.era slate.opponent_era
end
json.id pick.id
json.user_id pick.user_id
json.event pick.event, partial: 'v2/events/event', as: :event
json.selection do
  json.id pick.selection_id
  json.description pick.selection.description
end

json.cache! ["selection-{selection.id}", selection], expires_in: 5.minutes do
  json.id selection.id
  json.description selection.description
  json.event_id selection.event_id
  json.order selection.order
  json.selected selection.selected(current_user)
  json.status selection.status
end
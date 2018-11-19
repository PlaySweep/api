json.id slate.id
json.name slate.name
json.description slate.description
json.progress slate.progress(current_user.id)
json.events slate.events.each do |event|
  json.id event.id
  json.description event.description
  json.status event.status
  json.selections event.selections.each do |selection|
    json.id selection.id
    json.description selection.description
  end
end
json.status slate.status
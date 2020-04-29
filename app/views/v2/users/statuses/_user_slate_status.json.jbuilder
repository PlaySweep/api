json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.available_slates user.slates.available.each do |slate|
  json.id slate.id
  json.name slate.name
  json.status slate.status
  json.picks user.picks.where(event_id: slate.events.map(&:id)).each do |pick|
    json.id pick.id
    json.status pick.status
  end
end
json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.full_name user.full_name
json.handle user.handle
json.playing_streak user.playing_streak
json.confirmed user.confirmed
json.preference do
  json.owner_id user.preference.owner_id
  json.slate_messaging user.preference.slate_messaging
end
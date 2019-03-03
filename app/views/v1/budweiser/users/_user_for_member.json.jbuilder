json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.full_name user.full_name
json.handle user.handle
json.email user.email
json.dob user.dob
json.zipcode user.zipcode
json.playing_streak user.playing_streak
json.confirmed user.confirmed
json.preference do
  json.id user.preference.id
  json.owner_id user.preference.try(:owner_id)
  json.team_name user.preference.try(:team).try(:name)
  json.team_entry_image user.preference.try(:team).try(:entry_image)
  json.slate_messaging user.preference.slate_messaging
end
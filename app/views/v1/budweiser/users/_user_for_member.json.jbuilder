json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.full_name user.full_name
json.handle user.handle
json.email user.email
json.dob user.dob
json.zipcode user.zipcode
# json.playing_streak user.playing_streak
json.confirmed user.confirmed
json.locked user.locked
json.roles user.roles.where(resource_name: "Team").each do |role|
  json.id role.id
  json.owner_id role.resource_id
  json.team_name role.name
  json.team_entry_image Team.find(role.resource_id).try(:entry_image)
end
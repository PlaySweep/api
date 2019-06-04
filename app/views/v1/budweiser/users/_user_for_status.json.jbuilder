json.id user.id
json.facebook_uuid user.facebook_uuid
json.streak user.streak
json.initials user.initials
json.rank user.rank
json.ordinal_position user.ordinal_position
json.tied user.tied?
json.team_image user.roles.find_by(resource_type: "Team").resource.image
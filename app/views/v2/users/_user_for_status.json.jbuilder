json.id user.id
json.facebook_uuid user.facebook_uuid
json.current_sweep_streak user.current_sweep_streak
json.streak user.streak
json.initials user.initials
json.rank user.rank
json.ordinal_position user.ordinal_position
json.tied user.tied?
json.team_image user.roles.find_by(resource_type: "Team").try(:resource).try(:image) || user.default_image
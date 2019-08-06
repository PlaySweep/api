json.id role.id
json.owner_id role.resource_id
json.name role.name
json.team_name role.name.split('_').map(&:capitalize).join(' ')
json.team_entry_image Team.find(role.resource_id).try(:entry_image)
json.type role.resource_type
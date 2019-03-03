json.id preference.id
json.owner_id preference.owner_id
json.team do
  json.id preference.try(:team).try(:id)
  json.image preference.try(:team).try(:image)
  json.entry_image preference.try(:team).try(:entry_image)
  json.local_image preference.try(:team).try(:local_image)
end
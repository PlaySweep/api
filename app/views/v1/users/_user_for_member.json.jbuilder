json.id user.id
json.facebook_uuid user.facebook_uuid
json.first_name user.first_name
json.last_name user.last_name
json.full_name user.full_name
json.abbreviated_name user.abbreviated_name
json.handle user.handle
json.email user.email
json.dob user.dob
json.zipcode user.zipcode
json.confirmed user.confirmed
json.locked user.locked
json.slug user.slug
json.has_recently_won user.has_recently_won?
json.has_never_played user.has_never_played?
json.location user.location
json.roles user.roles.where(resource_type: "Team").each do |role|
  json.id role.id
  json.owner_id role.resource_id
  json.name role.name
  json.team_name role.name.split('_').map(&:capitalize).join(' ')
  json.team_image Team.find(role.resource_id).try(:image)
  json.team_entry_image Team.find(role.resource_id).try(:entry_image)
  json.local_image Team.find(role.resource_id).try(:local_image)
  json.type role.resource_type
  json.abbreviation Team.find(role.resource_id).try(:abbreviation)
end
json.account do
  json.id user.account.id
  json.name user.account.name
  json.image user.account.image
  json.friendly_name user.account.friendly_name
  json.app_name user.account.app_name
  json.tenant user.account.tenant
  json.images user.account.images.each do |image|
    json.id image.id
    json.description image.description
    json.category image.category
    json.url image.url
  end
end
json.copies user.account.copies.each do |copy|
  json.id copy.id
  json.category copy.category
  json.message copy.message
end
json.images user.account.images.each do |image|
  json.id image.id
  json.category image.category
  json.url image.url
end
json.links user.account.links.each do |link|
  json.id link.id
  json.category link.category
  json.url link.url
end
json.shipping user.shipping
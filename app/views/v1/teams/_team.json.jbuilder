json.id team.id
json.league team.league.name
json.name team.name
json.abbreviation team.abbreviation
json.image team.image
json.entry_image team.entry_image
json.local_image team.local_image
json.lat team.lat
json.long team.long
json.coordinates team.coordinates
json.division team.division
json.conference team.conference
json.promoted team.promoted
json.initials team.initials
json.time_zone team.time_zone
json.details do
  json.position team.try(:standing).try(:position)
  json.standing team.try(:standing).try(:records)
  json.division team.try(:standing).try(:division)
end
json.images team.images.each do |image|
  json.id image.id
  json.description image.description
  json.category image.category
  json.url image.url
end
json.active team.active
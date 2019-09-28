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
json.promoted team.promoted
json.initials team.initials
json.images team.images.each do |image|
  json.id image.id
  json.description image.description
  json.category image.category
  json.url image.url
end
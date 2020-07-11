json.id contest.id
json.name contest.name
json.description contest.description
json.status contest.status
json.prize do
  json.id contest.prize.id
  json.product do 
    json.id contest.prize.product.id
    json.name contest.prize.product.name
    json.category contest.prize.product.category
  end
  json.date contest.prize.date
end if contest.prize?
json.images contest.images
json.default_image_url contest.images.find_by(category: "Default").try(:url)
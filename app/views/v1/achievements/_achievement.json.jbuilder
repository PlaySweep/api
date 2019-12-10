json.id achievement.id
json.name achievement.name
json.description achievement.description
json.level achievement.level
json.difficulty achievement.difficulty
json.threshold achievement.threshold
json.disclaimer achievement.disclaimer
json.prize do
  json.id achievement.prize.id
  json.product do 
    json.id achievement.prize.product.id
    json.name achievement.prize.product.name
    json.category achievement.prize.product.category
  end
end if achievement.prize
json.id quiz.id
json.name quiz.name
json.description quiz.description
json.status quiz.status
json.start_time quiz.start_time
json.end_time quiz.end_time
json.played quiz.played?(current_user.id)
json.owner_id quiz.owner_id
json.winner quiz.winner, partial: 'v2/users/user_for_member', as: :user
json.prize do
  json.id quiz.prize.id
  json.product do 
    json.id quiz.prize.product.id
    json.name quiz.prize.product.name
    json.size quiz.prize.sku.try(:size)
    json.category quiz.prize.product.category
  end
  json.date quiz.prize.date
end
json.label "Trivia"
json.owner_image quiz.owner ? quiz.owner.image : "https://budweiser-sweep-assets.s3.amazonaws.com/mlb_national_logo.png"
json.questions quiz.questions.ordered, partial: 'v2/questions/question', as: :question
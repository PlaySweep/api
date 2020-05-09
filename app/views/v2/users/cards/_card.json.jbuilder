json.id card.id
json.user_id card.user_id
json.cardable_type card.cardable_type
json.cardable_id card.cardable_id
if card.cardable_type == "Quiz"
  json.quiz card.cardable
  json.questions card.cardable.questions, partial: 'v2/questions/question', as: :question
end
json.status card.status
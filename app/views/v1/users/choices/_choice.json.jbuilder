json.id choice.id
json.user_id choice.user_id
json.question choice.question, partial: 'v1/questions/question', as: :question
json.answer choice.answer, partial: 'v1/answers/answer', as: :answer
json.status choice.status
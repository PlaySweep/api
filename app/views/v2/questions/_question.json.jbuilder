json.id question.id
json.quiz_id question.quiz_id
json.quiz_type question.quiz.class.name
json.description question.description
json.order question.order
json.winners question.winners, partial: 'v2/answers/answer', as: :answer
json.answers question.answers.ordered, partial: 'v2/answers/answer', as: :answer
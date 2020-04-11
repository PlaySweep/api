json.id choice.id
json.user_id choice.user_id
json.question choice.question, partial: 'v1/questions/question', as: :question
json.question_session_speed choice.question.question_sessions.find_by(user_id: current_user.id, question_id: choice.question_id).try(:speed)
json.answer choice.answer, partial: 'v1/answers/answer', as: :answer
json.status choice.status
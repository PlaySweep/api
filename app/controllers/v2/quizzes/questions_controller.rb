class V2::Quizzes::QuestionsController < ApplicationController
  respond_to :json

  def show
    quiz = Quiz.find(params[:quiz_id])
    @question = quiz.questions.find_by(order: params[:order])
    if @question
      respond_with @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
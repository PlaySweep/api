class V1::QuizzesController < ApplicationController
  respond_to :json

  def index
    user = User.find_by(id: params[:user_id])
    if user
      @quizzes = Quiz.filtered(user.filtered_ids).ascending.available
      @quizzes = Quiz.filtered(user.filtered_ids).ascending.inactive if params[:inactive]
      respond_with @quizzes
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def show
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz
      respond_with @quiz
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def update
    @quiz = Quiz.find_by(id: params[:id])
    @quiz.update_attributes(quiz_params)
    if @quiz
      respond_with @quiz
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:status)
  end
end
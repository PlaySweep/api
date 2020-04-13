class V1::Users::QuizzesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @quizzes = @user.quizzes.finished.descending.limit(5) if params[:finished]
    respond_with @quizzes
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @quiz = @user.quizzes.find_by(id: params[:id])
    if @quiz
      respond_with @quiz
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

end
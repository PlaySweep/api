class V1::Users::QuizzesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    # @quizzes = @user.quizzes.started.descending if params[:started]
    # @quizzes = @user.quizzes.finished.since_last_week.descending if params[:finished]
    @quizzes = @user.quizzes.finished.since_last_week.descending if params[:finished]
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
class V2::Users::QuizzesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @quizzes = @user.quizzes.finished.descending.limit(3) if params[:finished]
    respond_with @quizzes
  end

end
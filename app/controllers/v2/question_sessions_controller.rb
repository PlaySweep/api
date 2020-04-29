class V2::QuestionSessionsController < ApplicationController
  respond_to :json

  def create
    @question_session = QuestionSession.create(question_session_params)
    if @question_session.save
      respond_with @question_session
    else
      render json: { errors: @question_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question_session = QuestionSession.find_by(id: params[:id])
    @question_session.update_attributes(question_session_params)
    if @question_session.save
      respond_with @question_session
    else
      render json: { errors: @question_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_session_params
    params.require(:question_session).permit(:user_id, :question_id, :status, :speed)
  end
end
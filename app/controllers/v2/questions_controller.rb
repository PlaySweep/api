class V2::QuestionsController < ApplicationController
  respond_to :json

  def show
    @question = Question.find_by(id: params[:id])
    if @question
      respond_with @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
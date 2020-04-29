class V2::Users::ChoicesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @choices = @user.choices.for_quiz(params[:quiz_id])
    respond_with @choices
  end

  def show
    user = User.find_by(id: params[:user_id])
    @choice = user.choices.find_by(id: params[:id])
    if @choice
      respond_with @choice
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def create
    @choice = Choice.create(choice_params)
    if @choice.save
      respond_with @choice
    else
      render json: { errors: @choice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @choice = Choice.find(params[:id])
    @choice.update_attributes(choice_params)
    if @choice.save
      respond_with @choice
    else
      render json: { errors: @choice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def choice_params
    params.require(:choice).permit(:user_id, :answer_id, :question_id, :status)
  end
end
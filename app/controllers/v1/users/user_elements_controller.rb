class V1::Users::UserElementsController < ApplicationController
  respond_to :json

  def index
    @user_elements = current_user.elements.for_saves
    respond_with @user_elements
  end

  def update
    @user_element = UserElement.find_by(id: params[:id])
    @user_element.update_attributes(user_element_params)
    if @user_element.save
      respond_with @user_element
    else
      render json: { errors: @user_element.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_element_params
    params.require(:user_element).permit(:used_for_id, :used_on_id, :used)
  end

end
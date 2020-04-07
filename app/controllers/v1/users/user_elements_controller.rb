class V1::Users::UserElementsController < ApplicationController
  respond_to :json

  def index
    @user_elements = current_user.elements.unused.for_saves
    respond_with @user_elements
  end

end
class V2::Users::SlatesController < ApplicationController
  respond_to :json

  def index
    @user = User.find_by(id: params[:user_id])
    @slates = @user.slates.started.descending if params[:started]
    @slates = @user.slates.finished.recent.descending
    respond_with @slates
  end

end
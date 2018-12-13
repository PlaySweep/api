class V1::SlatesController < ApplicationController
  respond_to :json

  def index
    @slates = current_user.slates.pending
    respond_with @slates
  end

  def show
    @slate = current_user.slates.pending.find(params[:id])
    respond_with @slate
  end
end
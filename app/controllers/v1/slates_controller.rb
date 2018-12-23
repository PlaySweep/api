class V1::SlatesController < ApplicationController
  respond_to :json

  def index
    @slates = Slate.pending
    respond_with @slates
  end

  def show
    @slate = Slate.pending.find(params[:id])
    respond_with @slate
  end
end
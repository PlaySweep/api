class V1::Users::StatusesController < ApplicationController
  respond_to :json

  def status
    @user = User.find(params[:id])
    respond_with @user
  end

  def slate_status
    @user = User.find(params[:id])
    respond_with @user
  end
end
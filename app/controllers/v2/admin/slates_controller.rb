class V2::Admin::SlatesController < ApplicationController
  respond_to :json

  def index
    if params[:global]
      @slates = Slate.unfiltered.for_admin
      respond_with @slates
    else
      team = Team.find(params[:team_id])
      @slates = team.slates.for_admin.descending
      respond_with @slates
    end
  end

  def show
    if params[:global]
      @slate = Slate.find(params[:id])
      respond_with @slate
    else
      team = Team.find(params[:team_id])
      @slate = team.slates.find(params[:id])
      respond_with @slate
    end
  end

  def create
    @slate = Slate.create(slate_params)
    respond_with @slate
  end

  def update
    @slate = Slate.find(params[:id])
    @slate.update_attributes(slate_params)
    respond_with @slate
  end

  def destroy
    @slate = Slate.find(params[:id])
    @slate.destroy
    respond_with @slate
  end

  private

  def data_params
    return params[:slate][:data] if params[:slate][:data].nil?
    JSON.parse(params[:slate][:data].to_json)
  end

  def slate_params
    params.require(:slate).permit(:name, :description, :start_time, :owner_id, :status, prizes_attributes: [:id, :product_id, :sku_id, :quantity, :date, :slate_id]).merge(data: data_params)
  end
end
class V2::Admin::ProductsController < ApplicationController
  respond_to :json

  def index
    if params[:global]
      @products = Product.where(global: true)
      respond_with @products
    else
      team = Team.find(params[:team_id])
      @products = team.products
      respond_with @products
    end
  end

  def show
    team = Team.find(params[:team_id])
    @product = team.products.find(params[:id])
    respond_with @product
  end
end
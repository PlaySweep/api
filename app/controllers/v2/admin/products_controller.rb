class V2::Admin::ProductsController < ApplicationController
  respond_to :json

  def index
    @products = Product.all
    @products = @products.filtered(params[:owner_id]) if params[:owner_id]
    respond_with @products
  end

  def show
    team = Team.find(params[:team_id])
    @product = team.products.find(params[:id])
    respond_with @product
  end
end
class Admin::ProductsController < AdminController
  respond_to :json

  def index
    team = Team.find(params[:team_id])
    @products = team.products
    respond_with @products
  end

  def show
    team = Team.find(params[:team_id])
    @product = team.products.find(params[:id])
    respond_with @product
  end
end
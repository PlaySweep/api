class V2::Admin::SkusController < BasicAuthenticationController
  respond_to :json

  def index
    @skus = Sku.all
    @skus = @skus.filtered(params[:product_id]) if params[:product_id]
    respond_with @skus
  end

  def show
    @sku = Sku.find(params[:id])
    respond_with @sku
  end

end
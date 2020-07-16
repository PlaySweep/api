class V2::Admin::SlatesController < BasicAuthenticationController
  respond_to :json

  def show
    @slate = Slate.find(params[:id])
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
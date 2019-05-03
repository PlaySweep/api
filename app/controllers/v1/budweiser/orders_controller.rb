class V1::Budweiser::OrdersController < BudweiserController
  respond_to :json


  def create
    @order = current_user.orders.create(order_params)
    if @order.save
      respond_with @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def data_params
    return params[:order][:data] if params[:order][:data].nil?
    JSON.parse(params[:order][:data].to_json)
  end

  def order_params
    params.require(:order).permit(:slate_id).merge(data: data_params)
  end
end
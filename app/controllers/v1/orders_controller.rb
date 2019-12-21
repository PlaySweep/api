class V1::OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Order.where(prize_id: params[:prize_id]) if params[:prize_id]
    respond_with @orders
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      respond_with @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:prize_id, :user_id)
  end
end
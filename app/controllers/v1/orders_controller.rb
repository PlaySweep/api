class V1::OrdersController < ApplicationController
  respond_to :json

  def create
    #TODO pass user_id from web
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
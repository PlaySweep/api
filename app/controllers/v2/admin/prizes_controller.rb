class V2::Admin::PrizesController < BasicAuthenticationController
  respond_to :json

  def index
    @prizes = Prize.all
    @prizes = @prizes.filtered_by_slate(params[:prizeable_id]) if params[:prizeable_id]
    respond_with @prizes
  end

  def show
    @prize = Prize.find(params[:id])
    respond_with @prize
  end

  def create
    @prize = Prize.create(prize_params)
    if @prize.save
      respond_with @prize
    else
      render json: { errors: @prize.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def prize_params
    params.require(:player).permit(:id, :product_id, :sku_id, :prizeable_type, :prizeable_id)
  end
end
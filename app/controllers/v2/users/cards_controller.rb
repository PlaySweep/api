class V2::Users::CardsController < ApplicationController
  respond_to :json

  def index
    @cards = Card.where(cardable_type: params[:cardable_type], cardable_id: params[:cardable_id])
    if @cards
      respond_with @cards
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def create
    @card = current_user.cards.create(cardable_type: params[:cardable_type], cardable_id: params[:cardable_id])
    if @card.save
      puts @card.errors.inspect
      respond_with @card
    else
      puts @card.errors.inspect
      render json: { errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @card = Card.find(params[:id])
    @card.update_attributes(card_params)
    if @card.save
      respond_with @card
    else
      render json: { errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(:status)
  end

end
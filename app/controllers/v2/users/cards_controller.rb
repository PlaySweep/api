class V2::Users::CardsController < ApplicationController
  respond_to :json

  def index
    @card = Card.find_by(cardable_type: params[:cardable_type], cardable_id: params[:cardable_id])
    if @card
      respond_with @card
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def show
    @card = Card.find(params[:id])
    if @card.save
      respond_with @card
    else
      render json: { errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @card = current_user.cards.create(cardable_type: params[:cardable_type], cardable_id: params[:cardable_id])
    if @card.save
      respond_with @card
    else
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
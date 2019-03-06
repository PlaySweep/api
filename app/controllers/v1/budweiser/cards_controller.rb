class V1::Budweiser::CardsController < BudweiserController
  respond_to :json

  def fetch_card_for_slate
    @card = current_user.cards.for_slate(params[:slate_id])
    respond_with @card
  end

  def create
    @card = current_user.cards.create(card_params)
    if @card.save
      Analytics::Budweiser::Card.new(@card).card_started
      respond_with @card
    else
      render json: { errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(:user_id, :slate_id)
  end
end
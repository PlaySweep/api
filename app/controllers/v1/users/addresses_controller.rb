class V1::Users::AddressesController < ApplicationController
  respond_to :json

  def create
    @address = current_user.addresses.create(address_params)
    if @address.save
      respond_with @address
    else
      puts @address.errors.inspect
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @address = Address.find(params[:id])
    @address.update_attributes(address_params)
    if @address.save
      respond_with @address
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:line1, :line2, :city, :state, :postal_code, :country, :formatted_address)
  end

end
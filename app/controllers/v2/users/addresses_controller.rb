class V2::Users::AddressesController < ApplicationController
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

  def data_params
    return params[:address][:data] if params[:address][:data].nil?
    JSON.parse(params[:address][:data].to_json)
  end

  def address_params
    params.require(:address).permit(:line1, :line2, :city, :state, :postal_code, :country, :formatted_address).merge(data: data_params)
  end

end
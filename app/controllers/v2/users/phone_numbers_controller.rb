class V2::Users::PhoneNumbersController < ApplicationController
  respond_to :json

  def create
    @phone_number = current_user.phone_numbers.create(phone_numbers_params)
    if @phone_number.save
      respond_with @phone_number
    else
      puts @phone_number.errors.inspect
      render json: { errors: @phone_number.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @phone_number = Address.find(params[:id])
    @phone_number.update_attributes(phone_numbers_params)
    if @phone_number.save
      respond_with @phone_number
    else
      render json: { errors: @phone_number.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def phone_numbers_params
    params.require(:phone_number).permit(:number)
  end

end
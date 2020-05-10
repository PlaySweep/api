class V1::Users::PhoneNumbersController < ApplicationController
  respond_to :json

  def create
    @phone_number = PhoneNumber.create(phone_numbers_params)
    if @phone_number.save
      respond_with @phone_number
    else
      puts @phone_number.errors.inspect
      render json: { errors: @phone_number.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def phone_numbers_params
    params.require(:phone_number).permit(:user_id, :number)
  end

end
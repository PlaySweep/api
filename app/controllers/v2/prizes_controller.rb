class V2::PrizesController < ApplicationController
    respond_to :json

    def show
      @prize = Prize.find(params[:id])
      if @prize
        respond_with @prize
      else
        render json: { errors: @prize.errors.full_messages }, status: :not_found
      end
    end

  end
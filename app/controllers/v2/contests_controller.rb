class V2::ContestsController < ApplicationController
    respond_to :json
  
    def index
      @contests = Contest.all
    end
  
    def show
      @contest = Contest.find_by(id: params[:id])
      if @contest
        respond_with @contest
      else
        render json: { errors: [] }, status: :unprocessable_entity
      end
    end
  
    private
  
    def contest_params
      params.require(:contest).permit(:contest)
    end
  end
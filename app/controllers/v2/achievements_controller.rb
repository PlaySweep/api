class V2::AchievementsController < ApplicationController
    respond_to :json

    def index
      @achievements = Achievement.order(level: :asc)
      respond_with @achievements
    end
  
  end
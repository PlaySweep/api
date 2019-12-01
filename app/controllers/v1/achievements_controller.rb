class V1::AchievementsController < ApplicationController
    respond_to :json

    def index
      @achievements = Achievement.all
      respond_with @achievements
    end
  
  end
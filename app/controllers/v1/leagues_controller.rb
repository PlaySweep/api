class V1::LeaguesController < ApplicationController
  def index
    @leagues = League.all
  end
end
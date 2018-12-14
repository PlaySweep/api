class Admin::EventsController < ApplicationController
  respond_to :json

  def create
    @event = Event.create(event_params)
    respond_with @event
  end

  private

  def event_params
    params.require(:event).permit(:description, :slate_id, :winner_ids, selections_attributes: [:description, :event_id])
  end
end
class V2::Admin::EventsController < BasicAuthenticationController
  respond_to :json

  def show
    @event = Event.find(params[:id])
    respond_with @event
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(event_params)
    respond_with @event
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_with @event
  end

  private

  def data_params
    return params[:event][:data] if params[:event][:data].nil?
    JSON.parse(params[:event][:data].to_json)
  end

  def event_params
    params.require(:event).permit(:description, :details, :slate_id, :status, :order, :type, selections_attributes: [:id, :description, :event_id, :order, :status]).merge(data: data_params)
  end
end
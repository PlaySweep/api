class V2::Users::SlatesController < ApplicationController
  respond_to :json

  def index
    @slates = current_user.slates.includes(:participants, events: :selections)
    @slates = @slates.started.descending if params[:started]
    @slates = @slates.finished.descending.limit(2)
    fresh_when last_modified: @slates.maximum(:updated_at), public: true
  end

end
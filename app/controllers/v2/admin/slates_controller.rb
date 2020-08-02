class V2::Admin::SlatesController < BasicAuthenticationController
  respond_to :json

  def index
    @slates = Slate.inactive
    @slates = Slate.filtered(params[:owner_id]) if params[:owner_id]
    respond_with @slates
  end

  def show
    @slate = Slate.find(params[:id])
    respond_with @slate
  end

  def update
    @slate = Slate.find(params[:id])
    @slate.update_attributes(slate_params)
    respond_with @slate
  end

  private

  def slate_params
    params.require(:slate).permit(:name, :description, :start_time, :status)
  end
end
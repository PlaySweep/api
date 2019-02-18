class Admin::SlatesController < AdminController
  respond_to :json

  def index
    team = Team.find(params[:team_id])
    @slates = team.slates
    respond_with @slates
  end

  def show
    team = Team.find(params[:team_id])
    @slate = team.slates.find(params[:id])
    respond_with @slate
  end

  def create
    @slate = Slate.create(slate_params)
    respond_with @slate
  end

  def update
    @slate = Slate.find(params[:id])
    @slate.update_attributes(slate_params)
    respond_with @slate
  end

  def destroy
    @slate = Slate.find(params[:id])
    @slate.destroy
    respond_with @slate
  end

  private

  def slate_params
    params.require(:slate).permit(:name, :description, :start_time, :type, :owner_id, :status)
  end
end
class V1::Budweiser::PreferencesController < BudweiserController
  respond_to :json

  def show
    @preference = Preference.find(params[:id])
    respond_with @preference
  end

  def update
    @preference = current_user.preference.update_attributes(preference_params)
    respond_with @preference
  end

  def set_owner
    team = Team.find_by(name: params[:team])
    @preference = current_user.preference
    @preference.update_attributes(owner_id: team.id)
    respond_with @preference
  end

  private

  def preference_params
    params.require(:preference).permit(:owner_id)
  end
end
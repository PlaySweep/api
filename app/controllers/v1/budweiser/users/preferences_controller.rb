class V1::Budweiser::Users::PreferencesController < BudweiserController
  respond_to :json

  def show
    @preference = Preference.find(params[:id])
    respond_with @preference
  end

  def update
    @preference = current_user.preference.update_attributes(preference_params)
    respond_with @preference
  end

  private

  def preference_params
    params.require(:preference).permit(:owner_id)
  end
end
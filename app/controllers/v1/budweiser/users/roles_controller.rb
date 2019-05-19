class V1::Budweiser::Users::RolesController < BudweiserController
  respond_to :json

  def create
    @role = current_user.add_role(params[:team_name], Team.find(params[:team_id]))
    respond_with @role
  end

end
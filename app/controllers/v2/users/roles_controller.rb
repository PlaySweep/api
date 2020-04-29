class V2::Users::RolesController < ApplicationController
  respond_to :json

  def create
    @role = current_user.add_role(params[:team_name], Team.find(params[:team_id]))
    respond_with @role
  end

end
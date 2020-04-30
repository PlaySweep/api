class V2::Users::RolesController < ApplicationController
  respond_to :json

  def create
    owner = Owner.find(params[:team_id])
    @role = current_user.add_role(params[:team_name], owner)
    respond_with @role
  end
end
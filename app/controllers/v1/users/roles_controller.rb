class V1::Users::RolesController < ApplicationController
  respond_to :json

  def create
    @role = current_user.add_role(params[:team_name], Team.find(params[:team_id]))
    respond_with @role
  end

  def change_teams
    user = User.find_by(id: params[:id])
    previous_role = user.roles.find_by(resource_type: "Team")
    if previous_role.present?
      unsubscribe user: user
      symbolized_role = previous_role.resource.name.downcase.split(' ').join('_').to_sym
      previous_team = previous_role.resource
      user.remove_role(symbolized_role, previous_team)
      team = Team.find_by(id: params[:team_id])
      team_symbol = params[:team_name].to_sym
      user.add_role(team_symbol, team)
      subscribe_to resource: team, user: user
    end
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      },
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    @role = user.roles.find_by(resource_type: "Team")
  end

end
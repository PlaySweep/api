class V1::Users::RolesController < ApplicationController
  respond_to :json

  def create
    @role = current_user.add_role(params[:team_name], Team.find(params[:team_id]))
    ConfirmAccountNotificationJob.perform_later(current_user.id)
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
      user.add_role(params[:team_name], Team.find(params[:team_id]))
      subscribe user: user
    end
    FacebookMessaging::Carousel.deliver_team(user)
    @role = user.roles.find_by(resource_type: "Team")
  end

  private

  def subscribe_to resource:, user:
    FacebookMessaging::Broadcast.subscribe(resource: resource, user: user)
  end

  def unsubscribe user:
    FacebookMessaging::Broadcast.unsubscribe(user: user)
  end

end
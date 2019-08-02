class V1::Budweiser::Users::RolesController < BudweiserController
  respond_to :json

  def create
    @role = current_user.add_role(params[:team_name], Team.find(params[:team_id]))
    ConfirmAccountNotificationJob.perform_later(current_user.id)
    respond_with @role
  end

  def change_teams
    previous_role = current_user.roles.find_by(resource_type: "Team")
    if previous_role.present?
      # unsubscribe user: current_user
      symbolized_role = previous_role.resource.name.downcase.split(' ').join('_').to_sym
      previous_team = previous_role.resource
      current_user.remove_role(symbolized_role, previous_team)
      current_user.add_role(params[:team_name], Team.find(params[:team_id]))
      # subscribe user: current_user
    end
    FacebookMessaging::Carousel.deliver_team(current_user)
    @role = current_user.roles.find_by(resource_type: "Team")
  end

  private

  def subscribe_to resource:, user:
    FacebookMessaging::Broadcast.subscribe(resource: resource, user: user)
  end

  def unsubscribe user:
    FacebookMessaging::Broadcast.unsubscribe(user: user)
  end

end
class UsersRoles < ApplicationRecord
  after_update :subscribe_user_to_broadcast

  private

  def subscribe_user_to_broadcast
    FacebookMessaging::Broadcast.subscribe(user_id) if Role.find_by(id: role_id).resource_type == "Team"
  end
end
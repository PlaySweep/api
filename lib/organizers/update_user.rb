class UpdateUser
  extend LightService::Organizer

  def self.call(user, params)
    with(user: user, params: params).reduce(
      TrackRegisteredNewUser,
      SendWelcomeRegistrationEmail,
      RemovePreviousOwnerRole,
      AssignNewOwnerRole,
      DeactivateUser
    )
  end
end

class TrackRegisteredNewUser
  extend ::LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:confirmation].nil?
      IndicativeTrackEventConfirmedAccountJob.perform_later(context.user.id)
    end
  end
end

class SendWelcomeRegistrationEmail
  extend ::LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:confirmation].nil?
      # TODO SendWelcomeRegistrationEmail
    end
  end
end

class RemovePreviousOwnerRole
  extend LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:team].nil?
      role = context.user.roles.find_by(resource_type: "Team")
      if role
        symbolized_role = role.resource.name.downcase.split(' ').join('_').to_sym
        context.user.remove_role(symbolized_role, role.resource)
      end
    end
  end
end

class AssignNewOwnerRole
  extend LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:team].nil?
      team = context.params[:team].upcase
      role = Owner.by_initials(team)
      symbolized_role_name = role.name.downcase.split(' ').join('_').to_sym
      context.user.add_role(symbolized_role_name, role)
    end
  end
end

class DeactivateUser
  extend LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:unsubscribe].nil?
      context.user.active = false
      context.user.save
    end
  end
end
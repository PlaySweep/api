class CreateNewUser
  extend LightService::Organizer

  def self.call(user, params)
    with(user: user, params: params).reduce(
      AssignCurrentAccount,
      ChecksForReferral,
      AssignOwnerRole,
      TrackNewUserEvent,
      SendWelcomeMessage
    )
  end
end

class AssignCurrentAccount
  extend LightService::Action
  expects :user

  executed do |context|
    account = Account.find_by(id: 1)
    context.user.account_id = account.id
    context.user.save
  end
end

class ChecksForReferral
  extend ::LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:referral_code].nil?
      referred_by = User.find_by(referral_code: context.params[:referral_code])
      context.user.referred_by_id = referred_by.id unless referred_by.nil?
      context.user.save
    end
  end
end

class AssignOwnerRole
  extend ::LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:team].nil?
      role = Owner.by_name(context.params[:team])
      symbolized_role_name = role.name.downcase.split(' ').join('_').to_sym
      context.user.add_role(symbolized_role_name, role)
    end
  end
end

class TrackNewUserEvent
  extend LightService::Action
  expects :user

  executed do |context|
    IndicativeTrackEventNewUserJob.perform_later(context.user.id)
  end
end

class SendWelcomeMessage
  extend LightService::Action
  expects :user, :params

  executed do |context|
    WelcomeJob.perform_later(context.user.id) if context.params[:onboard]
  end
end
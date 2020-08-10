class CreateNewUser
  extend LightService::Organizer

  def self.call(user, params)
    with(user: user, params: params).reduce(
      AssignCurrentAccount,
      AssignPhoneNumber,
      ChecksForReferral,
      AssignOwnerRole,
      TrackNewUserEvent,
      SendWelcomeMessage,
      TriggerRegistrationReminder
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

class AssignPhoneNumber
  extend LightService::Action
  expects :user, :params

  executed do |context|
    unless context.params[:phone_number].nil?
      phone_number = PhoneNumber.create(number: context.params[:phone_number], user_id: context.user.id)
      context.user.save
    end
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
      team = context.params[:team].upcase
      role = Owner.by_initials(team)
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

class TriggerRegistrationReminder
  extend LightService::Action
  expects :user, :params

  executed do |context|
    scheduled_job = RegistrationReminderJob.set(wait_until: 90.minutes.from_now).perform_later(context.user.id) if context.params[:onboard]
    SimpleBackgroundJob.perform_later("RegistrationReminderJob", scheduled_job.job_id, "User", context.user.id)
  end
end
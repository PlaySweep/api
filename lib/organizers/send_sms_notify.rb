class SendSmsNotify
  extend LightService::Organizer

  def self.call(user, client, params)
    with(user: user, client: client, params: params).reduce(
      CreateSMSBinding,
      TriggerNotification
    )
  end
end

class CreateSMSBinding
  extend ::LightService::Action
  expects :user, :client, :params

  executed do |context|
    unless context.params[:phone_number].nil?
      service = context.client.notify.v1.services(ENV["TWILIO_NOTIFY_#{current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"])
      identity = context.user.account.name.downcase.gsub(' ', '_')
      bind = service.bindings.create(
        identity: "#{identity}_#{context.user.id}",
        binding_type: 'sms',
        address: "Address=+#{context.params[:phone_number]}"
      )
      # TODO context.user.bindings.create(sid: bind.sid, type: "sms")
    end
  end
end

class TriggerNotification
  extend ::LightService::Action
  expects :user, :client, :params

  executed do |context|
    unless context.params[:onboard].nil?
      service = context.client.notify.v1.services(ENV["TWILIO_NOTIFY_#{current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"])
      notification = service.notifications.create(
        to_binding: { binding_type: 'sms', address: "+#{context.params[:phone_number]}"}.to_json,
        body: "Welcome to the #{context.user.account.app_name}!"
      )
    end
  end
end
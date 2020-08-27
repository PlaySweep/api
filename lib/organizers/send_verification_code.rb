class SendVerificationCode
  extend LightService::Organizer

  def self.call(current_account, client, params)
    with(current_account: current_account, client: client, params: params).reduce(
      GenerateVerifyCode
    )
  end
end

class GenerateVerifyCode
  extend ::LightService::Action
  expects :current_account, :client, :params

  executed do |context|
    unless context.params[:phone_number].nil?
      verification = context.client.verify
        .services("#{ENV["TWILIO_VERIFY_#{context.current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"]}") # TODO find a way to make this dynamic, without having access to user object yet
        .verifications
        .create(to: "+#{context.params[:phone_number]}", channel: "sms")
      verification.status == 'pending'
    end
  end
end
class HandleVerificationCheck
  extend LightService::Organizer

  def self.call(current_account, client, params)
    with(current_account: current_account, client: client, params: params).reduce(
      VerifyCodeCheck
    )
  end
end

class VerifyCodeCheck
  extend ::LightService::Action
  expects :current_account, :client, :params

  executed do |context|
    unless (context.params[:phone_number] || context.params[:code]).nil?
      verification_check = context.client.verify
        .services("#{ENV["TWILIO_VERIFY_#{context.current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"]}") # TODO find a way to make this dynamic, without having access to user object yet
        .verification_checks
        .create(to: "+#{context.params[:phone_number]}", code: context.params[:code])
      unless verification_check.status == 'approved'
        context.fail_and_return!("Failed to verify code.")
      end
    end
  end
end
class V2::Messaging::VerificationController < ApplicationController
  respond_to :json

  def verify
    service_url = "#{ENV["TWILIO_SMS_VERIFY_BASE_URL"]}/Service"
    account_sid = "#{ENV["TWILIO_SMS_VERIFY_ACCOUNT_SID_PRODUCTION"]}"
    auth_token = "#{ENV["TWILIO_SMS_VERIFY_AUTH_TOKEN_PRODUCTION"]}"
    client = Twilio::REST::Client.new(account_sid, auth_token)
    @verification = client.verify
                      .services("#{ENV["TWILIO_SMS_VERIFY_BUDWEISER_SWEEP_SERVICE_ID"]}")
                      .verifications
                      .create(to: "+1#{params[:phone_number]}", channel: "sms")
    puts @verification.inspect
  end

  def verify_check
    service_url = "#{ENV["TWILIO_SMS_VERIFY_BASE_URL"]}/Service"
    account_sid = "#{ENV["TWILIO_SMS_VERIFY_ACCOUNT_SID_PRODUCTION"]}"
    auth_token = "#{ENV["TWILIO_SMS_VERIFY_AUTH_TOKEN_PRODUCTION"]}"
    client = Twilio::REST::Client.new(account_sid, auth_token)
    @verification_check = client.verify
                      .services("#{ENV["TWILIO_SMS_VERIFY_BUDWEISER_SWEEP_SERVICE_ID"]}")
                      .verification_checks
                      .create(to: "+1#{params[:phone_number]}", code: params[:code])
    puts @verification_check.status
  end
end
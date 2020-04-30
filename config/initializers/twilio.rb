Twilio.configure do |config|
  config.account_sid = ENV["TWILIO_VERIFY_ACCOUNT_SID"]
  config.auth_token = ENV["TWILIO_VERIFY_AUTH_TOKEN"]
end 
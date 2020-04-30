class V2::Messaging::VerificationController < ApplicationController
  respond_to :json

  def verify
    client = Twilio::REST::Client.new
    @verification = client.verify
                      .services("#{ENV["TWILIO_VERIFY_#{current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"]}")
                      .verifications
                      .create(to: "+1#{params[:phone_number]}", channel: "sms")
    if @verification.status == "pending"
      respond_with @verification
    else 
      render json: { status: "error" }
    end
  end

  def verify_check
    client = Twilio::REST::Client.new
    @verification_check = client.verify
                      .services("#{ENV["TWILIO_VERIFY_#{current_account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"]}")
                      .verification_checks
                      .create(to: "+1#{params[:phone_number]}", code: params[:code])
    if @verification_check.status == "approved"
      respond_with @verification_check
    else 
      render json: { status: "pending" }
    end
  end
end
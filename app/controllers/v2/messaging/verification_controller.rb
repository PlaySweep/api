class V2::Messaging::VerificationController < ApplicationController
  respond_to :json

  def verify
    client = Twilio::REST::Client.new
    service_result = SendVerificationCode.call(current_account, client, params)

    if service_result.success?
      render json: { to: params[:phone_number], status: "pending", valid: false }
    else
      render json: { status: "error" }
    end
  end

  def verify_check
    client = Twilio::REST::Client.new
    service_result = HandleVerificationCheck.call(current_account, client, params)

    if service_result.success?
      render json: { to: params[:phone_number], status: "approved", valid: true }
    else
      render json: { status: "error" }
    end
  end
end
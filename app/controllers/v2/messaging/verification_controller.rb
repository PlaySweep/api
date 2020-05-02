class V2::Messaging::VerificationController < ApplicationController
  respond_to :json
  skip_before_action :authenticate!

  def verify
    client = Twilio::REST::Client.new
    service_result = SendVerificationCode.call(current_account, client, params)

    if service_result.success?
      render json: { status: { code: 200, to: params[:phone_number], status: "pending", valid: false } }
    else
      render json: { status: { code: 404 } }
    end
  end

  def verify_check
    client = Twilio::REST::Client.new
    service_result = HandleVerificationCheck.call(current_account, client, params)

    if service_result.success?
      render json: { status: { code: 200, to: params[:phone_number], status: "approved", valid: true } }
    else
      render json: { status: { code: 404 } }
    end
  end
end
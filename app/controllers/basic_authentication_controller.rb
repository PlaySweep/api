class BasicAuthenticationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :http_basic_authenticate

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_LOGIN"] && password == ENV["ADMIN_SECRET"]
    end
  end
end
class BasicAuthenticationController < ApplicationController
  before_action :http_basic_authenticate

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_LOGIN"] && password == ENV["ADMIN_SECRET"]
    end
  end
end
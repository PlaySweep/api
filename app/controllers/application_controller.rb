class ApplicationController < ActionController::API
  helper_method :current_user

  def current_user
    @current_user ||= User.first
  end
end

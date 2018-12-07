class ApplicationController < ActionController::API
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(facebook_uuid: session[:facebook_uuid])
  end
end

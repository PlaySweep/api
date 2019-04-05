class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  before_action :authenticate!
  helper_method :current_user

  def authenticate!
    if request.env["HTTP_AUTHORIZATION"]
      session[:facebook_uuid] ||= request.env["HTTP_AUTHORIZATION"]
    else
      render json: [] 
    end
  end

  def current_user
    @current_user ||= User.find_by(facebook_uuid: session[:facebook_uuid])
  end
end

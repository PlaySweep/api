class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  before_action :load_schema, :authenticate!
  helper_method :current_user, :current_tenant

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

  def current_tenant
    Apartment::Tenant.switch!('public')
    @current_tenant ||= Tenant.find_by(subdomain: get_subdomain)
  end

  private

  def load_schema
    render json: { message: "Tenant not found." } and return unless current_tenant
    Apartment::Tenant.switch!(current_tenant.subdomain)
  end

  def get_subdomain
    if Rails.env.beta?
      return request.subdomain.split("-")[0]
    else
      return request.subdomain.split(".")[0]
    end
  end
end

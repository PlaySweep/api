class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  before_action :authenticate!
  helper_method :current_user, :current_account

  def subdomain
    request.subdomain.split('.')[0]
  end

  def authenticate!
    Apartment::Tenant.switch('public') do
      tenants = Account.all.map(&:tenant)
      if tenants.include?(subdomain) 
        if request.env["HTTP_AUTHORIZATION"]
          session[:facebook_uuid] ||= request.env["HTTP_AUTHORIZATION"]
        else
          render json: [] 
        end
      else
        render json: {error: "Subdomain does not exist"}.to_json
      end
    end
  end

  def current_account
    Apartment::Tenant.switch(subdomain) do
      @current_account ||= Account.find_or_create_by(tenant: subdomain)
    end
  end

  def current_user
    Apartment::Tenant.switch(subdomain) do
      @current_user ||= User.find_by(facebook_uuid: session[:facebook_uuid])
    end
  end
end

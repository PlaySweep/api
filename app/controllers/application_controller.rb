class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  before_action :authenticate!
  helper_method :current_account

  def subdomain
    request.subdomain.split('.')[0]
  end

  def authenticate!
    Apartment::Tenant.switch('public') do
      tenants = Account.all.map(&:tenant)
      if tenants.include?(subdomain)
        current_account
      else
        render json: {error: "Subdomain does not exist"}.to_json
      end
    end
  end

  def current_account
    Apartment::Tenant.switch(subdomain) do
      @current_account ||= Account.find_by(tenant: subdomain)
    end
  end
end

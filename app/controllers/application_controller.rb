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
        authenticate_request
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

  def current_user
    Apartment::Tenant.switch(subdomain) do
      @current_user ||= User.find_by(id: params[:user_id])
    end
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end

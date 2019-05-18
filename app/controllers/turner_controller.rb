class TurnerController < ApplicationController
  before_action :switch_tenant!

  def switch_tenant!
    # Apartment::Tenant.switch!('turner')
  end
end

class BudweiserController < ApplicationController
  before_action :switch_tenant!

  def switch_tenant!
    Apartment::Tenant.switch!('budweiser')
  end
end

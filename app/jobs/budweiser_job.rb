class BudweiserJob < ApplicationJob
  before_perform :switch_tenant!

  private

  def switch_tenant!
    Apartment::Tenant.switch!('budweiser')
  end
end
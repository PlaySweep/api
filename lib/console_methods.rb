module ConsoleMethods
  def use_budweiser!
    Apartment::Tenant.switch!("budweiser")
  end
end
module ConsoleMethods
  def budweiser!
    Apartment::Tenant.switch!("budweiser")
  end

  def turner!
    Apartment::Tenant.switch!("turner")
  end
end
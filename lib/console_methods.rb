module ConsoleMethods
  def public!
    Apartment::Tenant.switch!("public")
  end

  def budweiser!
    Apartment::Tenant.switch!("budweiser")
  end

  def budlight!
    Apartment::Tenant.switch!("budlight")
  end

  def opry!
    Apartment::Tenant.switch!("opry")
  end

  def turner!
    Apartment::Tenant.switch!("turner")
  end
end
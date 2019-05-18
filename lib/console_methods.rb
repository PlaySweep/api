module ConsoleMethods
  def public!
    Apartment::Tenant.switch!("public")
  end
  
  def budweiser!
    Apartment::Tenant.switch!("budweiser")
  end

  def turner!
    Apartment::Tenant.switch!("turner")
  end
end
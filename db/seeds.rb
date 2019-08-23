require 'csv'

unless Rails.env.production?
  Apartment::Tenant.switch!('budlight')

end


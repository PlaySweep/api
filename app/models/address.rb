class Address < ApplicationRecord
  belongs_to :user

  store_accessor :data, :metadata

  before_save :format_address

  private

  def format_address
    street_number = ""
    route = ""
    metadata.select do |meta|
      if meta['types'] == ['street_number']
        street_number = meta['long_name']
      end
      if meta['types'] == ['route']
        route = meta['long_name']
      end

      self.line1 = "#{street_number} #{route}"

      if meta['types'] == ['locality', 'political']
        self.city = meta['long_name']
      end
      if meta['types'] == ['administrative_area_level_1', 'political']
        state = meta['long_name']
        self.state = meta['long_name']
      end
      if meta['types'] == ['postal_code']
        self.postal_code = meta['long_name']
      end
      self.country = "USA"
    end
  end
end
class DataJob < ApplicationJob
  @queue = :data_job

  def perform
    users = User.joins(:location).where('users.zipcode is not null and locations.user_id is null')
    users.first(750).each do |user|
      location = Geocoder.search(user.zipcode).select { |result| result.country_code == "us" }.first
      Location.find_or_create_by(user_id: user.id).update_attributes(city: location.try(:city), state: location.try(:state), postcode: user.zipcode, lat: location.try(:coordinates).try(:first), long: location.try(:coordinates).try(:last), country: location.try(:country), country_code: location.try(:country_code))
    end
  end
end
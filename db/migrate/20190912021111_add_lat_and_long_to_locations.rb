class AddLatAndLongToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :lat, :string
    add_column :locations, :long, :string
  end
end

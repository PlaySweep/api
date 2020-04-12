class AddTimeZonesToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :time_zone, :string, default: "Eastern Time (US & Canada)"
  end
end

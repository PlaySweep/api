class AddActiveToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :active, :boolean, default: false
  end
end

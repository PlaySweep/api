class AddPromotedToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :promoted, :boolean, default: false
  end
end

class AddDataColumnToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :data, :jsonb, default: {}
  end
end

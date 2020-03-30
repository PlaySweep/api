class AddDataToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :data, :jsonb, default: {}
  end
end

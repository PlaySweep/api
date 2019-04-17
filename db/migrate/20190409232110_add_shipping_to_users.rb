class AddShippingToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :shipping, :jsonb, default: {}
  end
end

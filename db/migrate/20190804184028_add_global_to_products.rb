class AddGlobalToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :global, :boolean, default: false
  end
end

class AddDefaultToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :default, :boolean, default: false
  end
end

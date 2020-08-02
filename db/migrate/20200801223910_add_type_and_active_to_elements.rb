class AddTypeAndActiveToElements < ActiveRecord::Migration[5.2]
  def change
    add_column :elements, :type, :string, default: "Element"
    add_column :elements, :active, :boolean, default: false
  end
end

class AddCategoryToElements < ActiveRecord::Migration[5.2]
  def change
    add_column :elements, :category, :string
  end
end

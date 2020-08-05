class AddDetailsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :details, :text
  end
end

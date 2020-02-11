class AddUploadedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uploaded, :boolean, default: false
  end
end

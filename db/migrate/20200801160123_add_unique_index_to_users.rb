class AddUniqueIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :facebook_uuid, unique: true
  end
end

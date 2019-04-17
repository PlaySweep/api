class RemoveAdminsTable < ActiveRecord::Migration[5.2]
  def change
     drop_table :admins do
      t.string :username
      t.string :password_digest
      t.timestamps
     end
  end
end

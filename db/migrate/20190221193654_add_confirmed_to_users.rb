class AddConfirmedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirmed, :boolean, default: false
  end
end

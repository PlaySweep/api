class AddUniqueIndexToOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, [:prize_id, :user_id], unique: true
  end
end

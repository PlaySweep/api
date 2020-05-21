class AddUniqueIndexForCards < ActiveRecord::Migration[5.2]
  def change
    add_index :cards, [:user_id, :cardable_id, :cardable_type], unique: true
  end
end

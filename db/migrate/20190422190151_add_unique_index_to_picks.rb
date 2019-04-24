class AddUniqueIndexToPicks < ActiveRecord::Migration[5.2]
  def change
    add_index :picks, [:selection_id, :user_id], unique: true
  end
end

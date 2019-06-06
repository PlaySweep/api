class AddUniqueIndexWithEventIdToPicks < ActiveRecord::Migration[5.2]
  def change
    add_index :picks, [:event_id, :user_id], unique: true
  end
end

class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.boolean :used, default: false
      t.timestamps
    end
  end
end

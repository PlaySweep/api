class CreateNudges < ActiveRecord::Migration[5.2]
  def change
    create_table :nudges do |t|
      t.integer :nudger_id, foreign_key: true, index: true
      t.integer :nudged_id, foreign_key: true, index: true
      t.integer :started, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

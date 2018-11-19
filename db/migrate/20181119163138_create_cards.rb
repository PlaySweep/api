class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.references :user, foreign_key: true, index: true
      t.references :slate, foreign_key: true, index: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end

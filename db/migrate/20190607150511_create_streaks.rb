class CreateStreaks < ActiveRecord::Migration[5.2]
  def change
    create_table :streaks do |t|
      t.string :type
      t.integer :current, default: 0
      t.integer :highest, default: 0
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end

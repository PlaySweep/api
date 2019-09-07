class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.string :type
      t.string :category
      t.boolean :used, default: false
      t.integer :used_by, foreign_key: true, index: true
      t.integer :slate_id, foreign_key: true, index: true
      t.float :value
      t.string :code
      t.integer :level, default: 0

      t.timestamps
    end
  end
end

class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.references :item, foreign_key: true
      t.string :description
      t.string :category
      t.integer :order

      t.timestamps
    end
  end
end

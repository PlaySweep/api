class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :template, foreign_key: true
      t.string :description
      t.string :category
      t.integer :order

      t.timestamps
    end
  end
end

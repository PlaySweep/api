class CreatePrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :prizes do |t|
      t.references :slate, foreign_key: true, index: true
      t.references :product, foreign_key: true, index: true
      t.references :sku, foreign_key: true, index: true
      t.integer :quantity, default: 1
      t.string :category
      t.timestamps
    end
  end
end

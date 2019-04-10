class CreateSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :skus do |t|
      t.string :code
      t.references :product, foreign_key: true, index: true
      t.integer :quantity
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end

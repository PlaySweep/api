class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :description
      t.string :url
      t.string :category
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end

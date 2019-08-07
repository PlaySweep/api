class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :description
      t.string :url
      t.string :category
      t.boolean :active, default: false

      t.references :imageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

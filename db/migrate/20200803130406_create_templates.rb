class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.references :owner, foreign_key: true, optional: true
      t.string :name
      t.string :category
      t.boolean :active, default: true

      t.timestamps
    end
  end
end

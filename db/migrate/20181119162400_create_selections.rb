class CreateSelections < ActiveRecord::Migration[5.2]
  def change
    create_table :selections do |t|
      t.string :description
      t.references :event, foreign_key: true, index: true
      t.timestamps
    end
  end
end

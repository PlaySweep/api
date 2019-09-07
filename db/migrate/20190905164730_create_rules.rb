class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name
      t.string :abbreviation
      t.string :category
      t.boolean :eligible, default: false
      t.integer :level, default: 0
      t.string :type, default: "Rule"

      t.timestamps
    end
  end
end

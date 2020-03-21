class CreateSlates < ActiveRecord::Migration[5.2]
  def change
    create_table :slates do |t|
      t.string :name
      t.string :description
      t.datetime :start_time
      t.string :type, default: "Slate"
      t.integer :status, default: 0
      t.references :owner, foreign_key: true, index: true
  
      t.timestamps
    end
  end
end

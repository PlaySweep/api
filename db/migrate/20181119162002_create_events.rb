class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :description
      t.integer :status, default: 0
      t.jsonb :data, default: {}
      t.references :slate, foreign_key: true, index: true
      t.string :type, default: "Event"
      t.integer :order
      t.timestamps
    end
  end
end

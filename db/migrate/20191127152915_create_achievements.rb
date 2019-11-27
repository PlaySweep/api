class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.string :name
      t.text :description
      t.integer :level
      t.string :type
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end

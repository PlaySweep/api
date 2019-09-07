class DropPreferences < ActiveRecord::Migration[5.2]
  def change
    drop_table :preferences do
     t.integer :user_id
     t.string :type
     t.jsonb :data
     t.timestamps
    end
  end
end

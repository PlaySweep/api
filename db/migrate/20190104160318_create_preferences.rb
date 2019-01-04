class CreatePreferences < ActiveRecord::Migration[5.2]
  def change
    create_table :preferences do |t|
      t.integer :user_id, foreign_key: true
      t.string :type, default: "Preference"
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end

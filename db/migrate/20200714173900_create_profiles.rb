class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.references :owner, foreign_key: true, index: true
      t.jsonb :data

      t.timestamps
    end
  end
end

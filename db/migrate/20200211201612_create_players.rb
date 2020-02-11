class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.references :owner, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end

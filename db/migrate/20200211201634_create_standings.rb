class CreateStandings < ActiveRecord::Migration[5.2]
  def change
    create_table :standings do |t|
      t.references :owner, foreign_key: true
      t.string :position
      t.string :records

      t.timestamps
    end
  end
end

class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :account, foreign_key: true
      t.string :image
      t.timestamps
    end
  end
end

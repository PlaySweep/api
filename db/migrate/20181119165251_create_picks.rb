class CreatePicks < ActiveRecord::Migration[5.2]
  def change
    create_table :picks do |t|
      t.references :user, foreign_key: true, index: true
      t.references :selection, foreign_key: true, index: true
      t.references :event, foreign_key: true, index: true
      t.timestamps
    end
  end
end

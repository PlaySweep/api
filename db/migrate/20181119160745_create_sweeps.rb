class CreateSweeps < ActiveRecord::Migration[5.2]
  def change
    create_table :sweeps do |t|
      t.references :user, foreign_key: true, index: true
      t.datetime :date
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end

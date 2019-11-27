class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.references :user, foreign_key: true, index: true
      t.references :achievement, foreign_key: true, index: true
      t.integer :status, default: 1
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end

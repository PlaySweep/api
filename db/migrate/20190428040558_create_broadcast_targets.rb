class CreateBroadcastTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :broadcast_targets do |t|
      t.string :name
      t.string :label_id
      t.string :category
      t.string :description
      t.jsonb :data, default: {}
      t.references :targetable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

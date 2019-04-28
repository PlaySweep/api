class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :body
      t.string :creative_id
      t.datetime :schedule_time
      t.string :category
      t.string :broadcast_id
      t.datetime :failed_at
      t.boolean :used, default: false
      t.jsonb :data, default: {}
      t.references :messageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

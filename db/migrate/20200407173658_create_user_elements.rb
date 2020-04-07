class CreateUserElements < ActiveRecord::Migration[5.2]
  def change
    create_table :user_elements do |t|
      t.references :user, foreign_key: true
      t.references :element, foreign_key: true
      t.integer :used_for_id, foreign_key: true, optional: true
      t.integer :used_on_id, foreign_key: true, optional: true
      t.datetime :used_at
      t.boolean :used, default: false

      t.timestamps
    end
  end
end

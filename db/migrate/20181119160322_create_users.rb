class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :facebook_uuid
      t.string :first_name
      t.string :last_name
      t.string :handle
      t.string :email
      t.string :phone_number
      t.string :avatar
      t.string :gender
      t.integer :timezone
      t.jsonb :data, default: {}
      t.boolean :active, default: true
      t.timestamps
    end
  end
end

class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests do |t|
      t.string :name
      t.string :description
      t.integer :account_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

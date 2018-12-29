class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :name
      t.references :account, foreign_key: true
      t.string :image
      t.string :type, default: "Owner"
      t.timestamps
    end
  end
end

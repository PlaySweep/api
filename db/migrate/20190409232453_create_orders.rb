class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, index: true
      t.references :prize, foreign_key: true, index: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end

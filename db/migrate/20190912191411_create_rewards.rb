class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :description
      t.string :category
      t.boolean :active, default: false
      t.references :rewardable, polymorphic: true, index: true

      t.timestamps
    end
  end
end

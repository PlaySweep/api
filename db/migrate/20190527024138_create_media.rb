class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media do |t|
      t.string :attachment_id
      t.string :url
      t.string :category
      t.references :imageable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

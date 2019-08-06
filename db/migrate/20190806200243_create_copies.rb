class CreateCopies < ActiveRecord::Migration[5.2]
  def change
    create_table :copies do |t|
      t.string :type
      t.string :category
      t.text :message
      t.references :copyable, polymorphic: true, index: true

      t.timestamps
    end
  end
end

class AddSlateIdToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :slate_id, :integer, foreign_key: true
  end
end

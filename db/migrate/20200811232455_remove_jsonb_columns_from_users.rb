class RemoveJsonbColumnsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :data, :jsonb
    remove_column :users, :shipping, :jsonb
  end
end

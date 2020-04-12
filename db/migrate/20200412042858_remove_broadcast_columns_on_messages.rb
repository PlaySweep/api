class RemoveBroadcastColumnsOnMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :creative_id, :string
    remove_column :messages, :broadcast_id, :string
  end
end

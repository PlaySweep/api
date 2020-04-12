class RemoveBroadcastColumnsFromOwners < ActiveRecord::Migration[5.2]
  def change
    remove_column :owners, :broadcast_message_id, :string
    remove_column :owners, :broadcast_label_id, :string
  end
end

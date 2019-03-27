class AddBroadcastColumnsToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :broadcast_message_id, :integer
    add_column :owners, :broadcast_label_id, :integer
  end
end

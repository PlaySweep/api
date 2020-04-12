class AddColumnsToOwners < ActiveRecord::Migration[5.2]
  def change
    add_column :owners, :broadcast_message_id, :string
    add_column :owners, :broadcast_label_id, :string
  end
end

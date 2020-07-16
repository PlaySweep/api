class RemoveOwnerFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :owner_id, :integer
  end
end

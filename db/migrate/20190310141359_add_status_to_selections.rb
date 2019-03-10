class AddStatusToSelections < ActiveRecord::Migration[5.2]
  def change
    add_column :selections, :status, :integer, default: 0
  end
end

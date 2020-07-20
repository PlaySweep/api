class AddActiveToCopies < ActiveRecord::Migration[5.2]
  def change
    add_column :copies, :active, :boolean, default: false
  end
end

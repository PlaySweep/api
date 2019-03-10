class AddSlateIdToSweeps < ActiveRecord::Migration[5.2]
  def change
    add_column :sweeps, :slate_id, :integer, foreign_key: true
  end
end

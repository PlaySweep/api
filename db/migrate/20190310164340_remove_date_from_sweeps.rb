class RemoveDateFromSweeps < ActiveRecord::Migration[5.2]
  def change
    remove_column :sweeps, :date, :datetime
  end
end
